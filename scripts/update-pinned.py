#!/usr/bin/env python3
"""Check and bump the pinned release downloads (Neovim, lazygit, fzf, delta,
eza, starship, win32yank).

Each tool's version and sha256 checksums live in a role's defaults/main.yml.
This script reads them, asks GitHub for the latest release, and rewrites the
version and checksums in place (comments and layout are preserved).

    scripts/update-pinned.py check                # what's out of date?
    scripts/update-pinned.py notes <tool>         # release notes since the pin
    scripts/update-pinned.py bump <tool>          # pin the latest release
    scripts/update-pinned.py bump <tool> 1.2.3    # pin a specific release
    scripts/update-pinned.py bump <tool> --dry-run
    scripts/update-pinned.py verify               # pinned checksums still match?

bump only edits the repo. Apply it with the playbook tag it prints, e.g.
    ansible-playbook playbook.yml -e @personal-config.yml --tags neovim -K

Checksums come from the sha256 digest GitHub publishes for each release
asset; when an asset has none (older releases), the file is downloaded and
hashed instead. Set GITHUB_TOKEN to raise the API rate limit (60/hour
unauthenticated, which is plenty for normal use).

See docs/updating-pinned-tools.md for the full workflow.
"""

import argparse
import hashlib
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent

# How each pinned tool maps onto GitHub releases and the repo's defaults.
#   tag_prefix  release tag = tag_prefix + stored version ("v" + "0.64.1")
#   assets      release asset per architecture key used in the checksum map;
#               {version} is the stored version. Must match the role's URL.
#   checksum_var is a {arch: "sha256:..."} map, or a single string when
#   checksum_is_scalar (win32yank is x86_64-only).
#   playbook_tag  the --tags value that (re)installs the tool
TOOLS = {
    "neovim": {
        "repo": "neovim/neovim",
        "file": "roles/neovim/defaults/main.yml",
        "version_var": "neovim_version",
        "checksum_var": "neovim_tarball_checksums",
        "tag_prefix": "",  # neovim_version stores the tag itself ("v0.12.4")
        "assets": {
            "x86_64": "nvim-linux-x86_64.tar.gz",
            "aarch64": "nvim-linux-arm64.tar.gz",
        },
        "playbook_tag": "neovim",
    },
    "lazygit": {
        "repo": "jesseduffield/lazygit",
        "file": "roles/common-software/defaults/main.yml",
        "version_var": "lazygit_version",
        "checksum_var": "lazygit_checksums",
        "tag_prefix": "v",
        "assets": {
            "x86_64": "lazygit_{version}_linux_x86_64.tar.gz",
            "aarch64": "lazygit_{version}_linux_arm64.tar.gz",
        },
        "playbook_tag": "lazygit",
    },
    "fzf": {
        "repo": "junegunn/fzf",
        "file": "roles/common-software/defaults/main.yml",
        "version_var": "fzf_version",
        "checksum_var": "fzf_checksums",
        "tag_prefix": "v",
        "assets": {
            "x86_64": "fzf-{version}-linux_amd64.tar.gz",
            "aarch64": "fzf-{version}-linux_arm64.tar.gz",
        },
        "playbook_tag": "fzf",
    },
    "delta": {
        "repo": "dandavison/delta",
        "file": "roles/common-software/defaults/main.yml",
        "version_var": "delta_version",
        "checksum_var": "delta_checksums",
        "tag_prefix": "",
        "assets": {
            "x86_64": "delta-{version}-x86_64-unknown-linux-gnu.tar.gz",
            "aarch64": "delta-{version}-aarch64-unknown-linux-gnu.tar.gz",
        },
        "playbook_tag": "delta",
    },
    "eza": {
        "repo": "eza-community/eza",
        "file": "roles/common-software/defaults/main.yml",
        "version_var": "eza_version",
        "checksum_var": "eza_checksums",
        "tag_prefix": "v",
        "assets": {
            "x86_64": "eza_x86_64-unknown-linux-gnu.tar.gz",
            "aarch64": "eza_aarch64-unknown-linux-gnu.tar.gz",
        },
        "playbook_tag": "eza",
    },
    "starship": {
        "repo": "starship/starship",
        "file": "roles/zsh/defaults/main.yml",
        "version_var": "starship_version",
        "checksum_var": "starship_checksums",
        "tag_prefix": "v",
        "assets": {
            "x86_64": "starship-x86_64-unknown-linux-musl.tar.gz",
            "aarch64": "starship-aarch64-unknown-linux-musl.tar.gz",
        },
        "playbook_tag": "zsh",
    },
    "win32yank": {
        "repo": "equalsraf/win32yank",
        "file": "roles/common-software/defaults/main.yml",
        "version_var": "win32yank_version",
        "checksum_var": "win32yank_checksum",
        "checksum_is_scalar": True,
        "tag_prefix": "v",
        "assets": {"x86_64": "win32yank-x64.zip"},
        "playbook_tag": "clipboard",
    },
}


class Error(Exception):
    pass


# --- GitHub ------------------------------------------------------------------

def _request(url):
    headers = {"User-Agent": "ansible-dev-setup/update-pinned"}
    if url.startswith("https://api.github.com/"):
        headers["Accept"] = "application/vnd.github+json"
        token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
        if token:
            headers["Authorization"] = f"Bearer {token}"
    try:
        return urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=60)
    except urllib.error.HTTPError as e:
        if e.code == 403 and "rate limit" in e.read().decode(errors="replace").lower():
            raise Error("GitHub API rate limit hit; wait an hour or set GITHUB_TOKEN") from None
        if e.code == 404:
            raise Error(f"not found: {url}") from None
        raise Error(f"HTTP {e.code} for {url}") from None
    except urllib.error.URLError as e:
        raise Error(f"cannot reach {url}: {e.reason}") from None


def api(path):
    with _request(f"https://api.github.com/{path}") as r:
        return json.load(r)


def latest_release(repo):
    """Latest non-prerelease, non-draft release (GitHub's own definition)."""
    return api(f"repos/{repo}/releases/latest")


def release_by_tag(repo, tag):
    return api(f"repos/{repo}/releases/tags/{tag}")


def asset_sha256(release, name):
    """Return ("sha256:...", source) for a named asset in a release."""
    for asset in release["assets"]:
        if asset["name"] == name:
            if (asset.get("digest") or "").startswith("sha256:"):  # null on old releases
                return asset["digest"], "github"
            h = hashlib.sha256()
            with _request(asset["browser_download_url"]) as r:
                for chunk in iter(lambda: r.read(1 << 20), b""):
                    h.update(chunk)
            return f"sha256:{h.hexdigest()}", "download"
    names = ", ".join(a["name"] for a in release["assets"]) or "(none)"
    raise Error(
        f"release {release['tag_name']} has no asset named {name!r}. "
        f"Upstream may have renamed its assets; update TOOLS in this script "
        f"and the role's download URL together. Assets: {names}"
    )


# --- repo defaults -------------------------------------------------------------

def load_defaults(tool):
    return yaml.safe_load((REPO_ROOT / TOOLS[tool]["file"]).read_text())


def pinned(tool):
    t = TOOLS[tool]
    data = load_defaults(tool)
    return str(data[t["version_var"]]), data[t["checksum_var"]]


def expected_checksums(tool, release, version):
    t = TOOLS[tool]
    return {
        arch: asset_sha256(release, tmpl.format(version=version))
        for arch, tmpl in t["assets"].items()
    }


def rewrite_defaults(tool, version, checksums):
    """Edit the version and checksum lines in place, keeping comments."""
    t = TOOLS[tool]
    path = REPO_ROOT / t["file"]
    text = path.read_text()

    def sub_once(pattern, repl, text):
        new, n = re.subn(pattern, repl, text, count=1, flags=re.M)
        if n != 1:
            raise Error(f"could not find {pattern!r} in {t['file']}")
        return new

    text = sub_once(rf'^({re.escape(t["version_var"])}:\s*)"[^"]*"', rf'\g<1>"{version}"', text)

    if t.get("checksum_is_scalar"):
        (value,) = checksums.values()
        text = sub_once(rf'^({re.escape(t["checksum_var"])}:\s*)"[^"]*"', rf'\g<1>"{value}"', text)
    else:
        lines = text.split("\n")
        start = next((i for i, l in enumerate(lines) if re.match(rf'^{re.escape(t["checksum_var"])}:\s*$', l)), None)
        if start is None:
            raise Error(f"could not find {t['checksum_var']}: in {t['file']}")
        for arch, value in checksums.items():
            for i in range(start + 1, len(lines)):
                if not lines[i].startswith((" ", "\t")):
                    raise Error(f"{t['checksum_var']} in {t['file']} has no {arch} entry")
                m = re.match(rf'^(\s+{re.escape(arch)}:\s*)"[^"]*"', lines[i])
                if m:
                    lines[i] = f'{m.group(1)}"{value}"'
                    break
        text = "\n".join(lines)

    # Round-trip check before writing: the file must still parse and hold
    # exactly the values we meant to write.
    data = yaml.safe_load(text)
    got = data[t["checksum_var"]]
    want = next(iter(checksums.values())) if t.get("checksum_is_scalar") else checksums
    if str(data[t["version_var"]]) != version or (got != want if t.get("checksum_is_scalar") else any(got.get(a) != v for a, v in want.items())):
        raise Error(f"rewrite of {t['file']} did not produce the expected values; nothing written")
    path.write_text(text)


# --- commands ------------------------------------------------------------------

def cmd_check(_args):
    outdated = 0
    print(f"{'tool':10} {'pinned':12} {'latest':12} status")
    for tool, t in TOOLS.items():
        current, _ = pinned(tool)
        try:
            latest = latest_release(t["repo"])["tag_name"]
        except Error as e:
            print(f"{tool:10} {current:12} {'?':12} error: {e}")
            continue
        latest_version = latest[len(t["tag_prefix"]):] if latest.startswith(t["tag_prefix"]) else latest
        if latest_version == current:
            status = "up to date"
        else:
            status = f"update available  (--tags {t['playbook_tag']})"
            outdated += 1
        print(f"{tool:10} {current:12} {latest_version:12} {status}")
    print(f"\n{outdated} tool(s) can be updated." if outdated else "\nEverything is up to date.")


def cmd_notes(args):
    t = TOOLS[args.tool]
    current, _ = pinned(args.tool)
    current_tag = t["tag_prefix"] + current
    releases = api(f"repos/{t['repo']}/releases?per_page=100")
    newer = []
    for rel in releases:  # newest first
        if rel["tag_name"] == current_tag:
            break
        if not rel["draft"] and not rel["prerelease"]:
            newer.append(rel)
    else:
        print(f"note: pinned tag {current_tag} not in the last {len(releases)} releases; showing all of them\n")
    if not newer:
        print(f"{args.tool} {current} is the latest release.")
        return
    for rel in newer:
        print("=" * 78)
        print(f"{rel['tag_name']}  ({rel['published_at'][:10]})  {rel['html_url']}")
        print("=" * 78)
        body = (rel.get("body") or "(no release notes)").replace("\r\n", "\n").strip().split("\n")
        if not args.full and len(body) > args.max_lines:
            body = body[: args.max_lines] + [f"... ({len(body) - args.max_lines} more lines; --full to show all)"]
        print("\n".join(body) + "\n")


def cmd_bump(args):
    tool = args.tool
    t = TOOLS[tool]
    current, _ = pinned(tool)
    if args.version:
        version = args.version
        if t["tag_prefix"] and version.startswith(t["tag_prefix"]) and not current.startswith(t["tag_prefix"]):
            version = version[len(t["tag_prefix"]):]  # accept "v0.65.0" for "0.65.0"-style pins
        release = release_by_tag(t["repo"], t["tag_prefix"] + version)
    else:
        release = latest_release(t["repo"])
        tag = release["tag_name"]
        version = tag[len(t["tag_prefix"]):] if tag.startswith(t["tag_prefix"]) else tag
    if version == current:
        print(f"{tool} is already pinned to {current}; nothing to do.")
        return

    checksums = expected_checksums(tool, release, version)
    print(f"{tool}: {current} -> {version}   ({release['html_url']})")
    for arch, (digest, source) in checksums.items():
        print(f"  {arch:8} {digest}  [{source}]")
    if args.dry_run:
        print("\n--dry-run: nothing written.")
        return
    rewrite_defaults(tool, version, {a: d for a, (d, _) in checksums.items()})
    print(f"\nUpdated {t['file']}. Next:")
    print(f"  ansible-playbook playbook.yml -e @personal-config.yml --tags {t['playbook_tag']} -K")
    print(f"  git commit -am \"chore: bump {tool} to {version}\"")


def cmd_verify(_args):
    """Confirm the pinned checksums match what GitHub serves for the pinned
    versions. Catches typos and asset-name drift in TOOLS."""
    bad = 0
    for tool, t in TOOLS.items():
        version, pinned_sums = pinned(tool)
        try:
            release = release_by_tag(t["repo"], t["tag_prefix"] + version)
            expected = expected_checksums(tool, release, version)
        except Error as e:
            print(f"{tool:10} {version:12} ERROR  {e}")
            bad += 1
            continue
        pinned_map = {"x86_64": pinned_sums} if t.get("checksum_is_scalar") else pinned_sums
        mismatches = [a for a, (d, _) in expected.items() if pinned_map.get(a) != d]
        if mismatches:
            bad += 1
            print(f"{tool:10} {version:12} MISMATCH ({', '.join(mismatches)})")
        else:
            sources = ",".join(sorted({s for _, s in expected.values()}))
            print(f"{tool:10} {version:12} ok  [{sources}]")
    if bad:
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0], formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("check", help="list pinned vs latest versions").set_defaults(func=cmd_check)
    p = sub.add_parser("notes", help="release notes for every release newer than the pin")
    p.add_argument("tool", choices=TOOLS)
    p.add_argument("--full", action="store_true", help="don't truncate long release notes")
    p.add_argument("--max-lines", type=int, default=80, help="lines per release when not --full (default 80)")
    p.set_defaults(func=cmd_notes)
    p = sub.add_parser("bump", help="pin a new version (latest by default) and its checksums")
    p.add_argument("tool", choices=TOOLS)
    p.add_argument("version", nargs="?", help="specific version instead of latest")
    p.add_argument("--dry-run", action="store_true", help="show what would change without writing")
    p.set_defaults(func=cmd_bump)
    sub.add_parser("verify", help="check pinned checksums against GitHub").set_defaults(func=cmd_verify)
    args = parser.parse_args()
    try:
        args.func(args)
    except Error as e:
        sys.exit(f"error: {e}")


if __name__ == "__main__":
    main()
