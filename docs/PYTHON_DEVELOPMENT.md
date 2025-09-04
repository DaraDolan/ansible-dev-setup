# Python Development Guide

This guide covers Python development in your Ansible-configured environment, focusing on UV package management, Neovim integration, and modern Python workflows.

## Table of Contents
- [Environment Overview](#environment-overview)
- [UV Package Manager](#uv-package-manager)
- [Neovim Python Integration](#neovim-python-integration)
- [Project Structure](#project-structure)
- [Development Workflows](#development-workflows)
- [Code Quality Tools](#code-quality-tools)
- [Testing](#testing)
- [Common Patterns](#common-patterns)
- [Troubleshooting](#troubleshooting)

## Environment Overview

Your development environment includes:
- **Python 3.x** - Core Python runtime
- **UV Package Manager** - Ultra-fast Python package installer and resolver (10-100x faster than pip)
- **Neovim with Python LSP** - Full language server support with pylsp
- **Python snippets** - Custom code snippets for rapid development
- **Treesitter syntax highlighting** - Advanced Python syntax highlighting
- **GitHub Copilot** - AI-powered code suggestions (when enabled)

## UV Package Manager

UV is your primary Python package manager, written in Rust for maximum performance.

### Quick Start
```bash
# Create new project
uv init my-python-project
cd my-python-project

# Add dependencies
uv add requests fastapi
uv add --dev pytest black ruff mypy

# Install and run
uv run python main.py
```

### Key Commands

#### Project Management
```bash
uv init <project-name>      # Create new Python project
uv init --lib <lib-name>    # Create new Python library
uv init --app <app-name>    # Create new Python application
```

#### Dependency Management
```bash
uv add <package>            # Add runtime dependency
uv add --dev <package>      # Add development dependency
uv add --optional <package> # Add optional dependency
uv remove <package>         # Remove dependency
uv sync                     # Sync environment with pyproject.toml
uv lock                     # Update uv.lock file
uv export > requirements.txt # Export to requirements.txt
```

#### Virtual Environment
```bash
uv venv                     # Create virtual environment (.venv)
uv venv --python 3.12       # Create with specific Python version
source .venv/bin/activate   # Activate environment (Linux/macOS)
.venv\\Scripts\\activate     # Activate environment (Windows)
```

#### Running Code
```bash
uv run python script.py     # Run Python script
uv run pytest              # Run tests
uv run <command>            # Run any command in project environment
```

#### Python Version Management
```bash
uv python install 3.12     # Install Python 3.12
uv python list             # List available Python versions
uv python pin 3.11         # Pin project to Python 3.11
```

## Neovim Python Integration

### Language Server Features
Your Neovim setup includes full Python LSP support via `pylsp`:

- **Code completion** - Intelligent autocompletion
- **Error checking** - Real-time syntax and semantic errors
- **Go to definition** - Jump to function/class definitions (`gd`)
- **Find references** - Find all usages of symbols (`gr`)
- **Hover documentation** - Show documentation (`K`)
- **Code actions** - Quick fixes and refactoring (`<leader>ca`)
- **Rename symbol** - Rename variables/functions (`<leader>rn`)

### Python Snippets
Available snippets (trigger with snippet prefix + Tab):

| Trigger | Description | Usage |
|---------|-------------|--------|
| `def` | Function definition | `def function_name(args):` |
| `class` | Class definition | `class ClassName:` |
| `main` | Main guard | `if __name__ == "__main__":` |
| `try` | Try-except block | `try: ... except Exception:` |
| `for` | For loop | `for item in iterable:` |
| `while` | While loop | `while condition:` |
| `test` | Pytest test function | `def test_function():` |
| `fastapi` | FastAPI route | `@app.get("/endpoint")` |
| `flask` | Flask route | `@app.route("/endpoint")` |
| `lc` | List comprehension | `[expr for item in iterable]` |
| `dc` | Dict comprehension | `{key: value for item in iterable}` |
| `pdb` | Print debug | `print(f"var: {var}")` |
| `doc` | Function docstring | Triple-quoted docstring with Args/Returns |

### Neovim Python Workflows
```bash
# Navigate to Python project
cd my-python-project

# Open in Neovim
nvim .

# Key workflows in Neovim:
# - <leader>ff - Find files (Telescope)
# - <leader>fg - Live grep search
# - <leader>ca - Code actions (imports, fixes)
# - gd - Go to definition
# - K - Show documentation
# - <leader>rn - Rename symbol
```

## Project Structure

### Recommended Python Project Layout
```
my-python-project/
├── pyproject.toml          # Project configuration (UV/pip)
├── uv.lock                 # Dependency lock file
├── README.md              # Project documentation
├── .env                   # Environment variables
├── .gitignore             # Git ignore patterns
├── src/
│   └── myproject/         # Main package
│       ├── __init__.py    # Package initialization
│       ├── main.py        # Application entry point
│       ├── cli.py         # Command-line interface
│       ├── config.py      # Configuration management
│       ├── models/        # Data models
│       │   ├── __init__.py
│       │   └── user.py
│       ├── services/      # Business logic
│       │   ├── __init__.py
│       │   └── auth.py
│       ├── api/           # API routes (FastAPI/Flask)
│       │   ├── __init__.py
│       │   ├── routes.py
│       │   └── middleware.py
│       └── utils/         # Utility functions
│           ├── __init__.py
│           └── helpers.py
├── tests/                 # Test suite
│   ├── __init__.py
│   ├── conftest.py        # Pytest configuration
│   ├── test_main.py       # Main application tests
│   ├── unit/              # Unit tests
│   │   └── test_models.py
│   └── integration/       # Integration tests
│       └── test_api.py
├── docs/                  # Documentation
│   ├── index.md
│   └── api.md
└── scripts/               # Utility scripts
    ├── setup.py
    └── deploy.py
```

### pyproject.toml Template
```toml
[project]
name = "myproject"
version = "0.1.0"
description = "My Python project"
authors = [{name = "Your Name", email = "your.email@example.com"}]
readme = "README.md"
requires-python = ">=3.9"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]
web = [
    "fastapi>=0.100.0",
    "uvicorn>=0.23.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]

[tool.black]
line-length = 100
target-version = ['py39']

[tool.ruff]
line-length = 100
target-version = "py39"
```

## Development Workflows

### 1. Starting a New Python Project
```bash
# Create project structure
uv init my-python-project
cd my-python-project

# Set up basic dependencies
uv add requests pydantic
uv add --dev pytest black ruff mypy

# Create basic structure
mkdir -p src/myproject/{models,services,api,utils} tests/{unit,integration} docs scripts

# Initialize Git
git init
echo "*.pyc\n__pycache__/\n.venv/\n.env\n*.egg-info/" > .gitignore

# Open in Neovim
nvim .
```

### 2. Daily Development Workflow
```bash
# Activate environment and start coding
cd my-python-project
source .venv/bin/activate  # If not using uv run

# Add new dependencies as needed
uv add new-package

# Run code during development
uv run python src/myproject/main.py

# Run tests frequently
uv run pytest

# Format and lint code
uv run black src/ tests/
uv run ruff check src/ tests/
```

### 3. FastAPI Development
```bash
# Set up FastAPI project
uv add fastapi uvicorn python-multipart

# Create main.py
cat > src/myproject/main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI(title="My API", version="0.1.0")

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
EOF

# Run development server
uv run uvicorn src.myproject.main:app --reload --host 0.0.0.0 --port 8000
```

### 4. Data Science Workflow
```bash
# Set up data science environment
uv add pandas numpy matplotlib jupyter plotly

# Start Jupyter Lab
uv run jupyter lab

# Or create analysis script
cat > analysis.py << 'EOF'
import pandas as pd
import matplotlib.pyplot as plt

# Load and analyze data
df = pd.read_csv('data.csv')
print(df.describe())
df.plot()
plt.show()
EOF
```

## Code Quality Tools

### 1. Black (Code Formatting)
```bash
# Install and use Black
uv add --dev black

# Format all Python files
uv run black src/ tests/

# Check what would be formatted
uv run black --check src/ tests/

# Format single file
uv run black src/myproject/main.py
```

### 2. Ruff (Linting and More)
```bash
# Install Ruff
uv add --dev ruff

# Lint code
uv run ruff check src/ tests/

# Auto-fix issues
uv run ruff check --fix src/ tests/

# Format code (alternative to Black)
uv run ruff format src/ tests/
```

### 3. MyPy (Type Checking)
```bash
# Install MyPy
uv add --dev mypy

# Type check code
uv run mypy src/

# With specific configuration
uv run mypy src/ --strict
```

### 4. Pre-commit Hooks
```bash
# Install pre-commit
uv add --dev pre-commit

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.9
    hooks:
      - id: ruff
        args: [--fix]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
EOF

# Install hooks
uv run pre-commit install
```

## Testing

### Pytest Basics
```bash
# Install pytest
uv add --dev pytest pytest-cov pytest-mock

# Run all tests
uv run pytest

# Run with coverage
uv run pytest --cov=src/myproject

# Run specific test file
uv run pytest tests/test_main.py

# Run specific test function
uv run pytest tests/test_main.py::test_function_name

# Run with verbose output
uv run pytest -v

# Run tests and stop on first failure
uv run pytest -x
```

### Test File Example
```python
# tests/test_main.py
import pytest
from src.myproject.main import my_function

def test_my_function():
    """Test my_function returns expected result."""
    # Arrange
    input_value = "test"
    expected_output = "processed_test"
    
    # Act
    result = my_function(input_value)
    
    # Assert
    assert result == expected_output

def test_my_function_with_empty_input():
    """Test my_function handles empty input."""
    with pytest.raises(ValueError):
        my_function("")

@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {"key": "value", "number": 42}

def test_with_fixture(sample_data):
    """Test using a fixture."""
    assert sample_data["number"] == 42
```

## Common Patterns

### 1. Configuration Management
```python
# src/myproject/config.py
import os
from typing import Optional
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "My App"
    debug: bool = False
    database_url: str
    api_key: Optional[str] = None
    
    class Config:
        env_file = ".env"

settings = Settings()
```

### 2. CLI Application with Click
```python
# Install: uv add click
# src/myproject/cli.py
import click

@click.group()
def cli():
    """My Python CLI application."""
    pass

@cli.command()
@click.option('--name', default='World', help='Name to greet')
@click.option('--count', default=1, help='Number of greetings')
def hello(name, count):
    """Simple program that greets NAME for a total of COUNT times."""
    for _ in range(count):
        click.echo(f'Hello {name}!')

if __name__ == '__main__':
    cli()
```

### 3. Database with SQLAlchemy
```python
# Install: uv add sqlalchemy alembic
# src/myproject/models/database.py
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)

# Database setup
engine = create_engine('sqlite:///app.db')
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)
```

### 4. Async Programming
```python
# src/myproject/services/async_service.py
import asyncio
import aiohttp
from typing import List

async def fetch_url(session: aiohttp.ClientSession, url: str) -> str:
    """Fetch single URL asynchronously."""
    async with session.get(url) as response:
        return await response.text()

async def fetch_multiple_urls(urls: List[str]) -> List[str]:
    """Fetch multiple URLs concurrently."""
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        return results

# Usage
if __name__ == "__main__":
    urls = ["https://example.com", "https://httpbin.org/json"]
    results = asyncio.run(fetch_multiple_urls(urls))
```

## Troubleshooting

### Common Issues and Solutions

#### UV Issues
```bash
# UV command not found
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# UV environment issues
uv sync  # Resync environment
rm -rf .venv && uv venv  # Recreate virtual environment
```

#### Python LSP Issues in Neovim
```vim
" Restart LSP in Neovim
:LspRestart

" Check LSP status
:LspInfo

" Format Python code manually
:lua vim.lsp.buf.format()
```

#### Import Resolution Issues
```python
# Add src to Python path in tests/conftest.py
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))
```

#### Virtual Environment Issues
```bash
# Deactivate current environment
deactivate

# Remove and recreate environment
rm -rf .venv
uv venv
source .venv/bin/activate
uv sync
```

### Performance Tips
- Use `uv run` instead of activating environments for one-off commands
- Leverage UV's parallel installation for faster dependency management
- Use `uv sync` instead of `uv install` to sync with lock file
- Enable UV's global cache for faster installs across projects

### Best Practices
- Always use `pyproject.toml` for project configuration
- Pin major versions in dependencies: `requests>=2.31.0,<3.0.0`
- Use development dependencies for tools: `uv add --dev pytest`
- Create comprehensive `.gitignore` files
- Use type hints and run `mypy` regularly
- Write tests early and run them frequently
- Use meaningful commit messages and branch names