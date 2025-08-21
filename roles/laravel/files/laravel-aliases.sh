# Laravel Development Aliases and Functions
# Automatically loaded in .zshrc for Laravel workflow optimization

# Development aliases for seamless workflow
alias cc='claude'
alias cce='claude edit'
alias nv='nvim'
alias art='php artisan'
alias serve='php artisan serve'
alias tinker='php artisan tinker'
alias migrate='php artisan migrate'
alias fresh='php artisan migrate:fresh --seed'
alias test='php artisan test'

# Quick project navigation
alias dev='cd ~/development'
alias projects='cd ~/development/projects'

# Laravel project shortcuts
laravel-new() {
    if [ -z "$1" ]; then
        echo "Usage: laravel-new project-name [react]"
        return 1
    fi
    
    cd ~/development/projects
    
    # Create Laravel project with Pest testing
    laravel new $1 --pest --git
    cd $1
    
    # Setup Tailwind CSS
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init -p
    
    # Update Tailwind config for Laravel
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.jsx",
    "./resources/**/*.tsx",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
    
    # Add Tailwind to CSS
    cat > resources/css/app.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
    
    # Setup basic React if requested
    if [ "$2" = "react" ]; then
        npm install react react-dom @types/react @types/react-dom
        npm install -D @vitejs/plugin-react typescript
        
        # Update Vite config for React
        cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.jsx'],
            refresh: true,
        }),
        react(),
    ],
});
EOF
        
        # Create basic React component
        mkdir -p resources/js/components
        cat > resources/js/components/Welcome.jsx << 'EOF'
import React from 'react';

export default function Welcome({ user }) {
    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
            <div className="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
                <h1 className="text-3xl font-bold text-gray-900 mb-4">
                    Welcome to Laravel + React!
                </h1>
                <p className="text-gray-600 mb-6">
                    Your development environment is ready with Pest testing, Tailwind CSS, and React.
                </p>
                {user && (
                    <p className="text-sm text-indigo-600">
                        Hello, {user.name}! 👋
                    </p>
                )}
            </div>
        </div>
    );
}
EOF
        
        # Update main JS file
        cat > resources/js/app.jsx << 'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import Welcome from './components/Welcome';
import '../css/app.css';

const container = document.getElementById('app');
const root = createRoot(container);
root.render(<Welcome />);
EOF
    fi
    
    # Install additional testing packages for better Pest experience
    composer require --dev pestphp/pest-plugin-laravel pestphp/pest-plugin-faker
    
    # Create sample Pest test
    cat > tests/Feature/ExampleTest.php << 'EOF'
<?php

use App\Models\User;

it('has welcome page', function () {
    $response = $this->get('/');
    $response->assertStatus(200);
});

it('can create users', function () {
    $user = User::factory()->create([
        'name' => 'John Doe',
        'email' => 'john@example.com',
    ]);

    expect($user->name)->toBe('John Doe');
    expect($user->email)->toBe('john@example.com');
});

it('can authenticate users', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
         ->get('/dashboard')
         ->assertStatus(200);
});
EOF

    # Create Unit test example
    cat > tests/Unit/ExampleTest.php << 'EOF'
<?php

it('returns true', function () {
    expect(true)->toBeTrue();
});

it('can perform basic math', function () {
    expect(2 + 2)->toBe(4);
    expect(10 / 2)->toBe(5);
});

it('can work with arrays', function () {
    $array = ['laravel', 'pest', 'tailwind'];
    
    expect($array)
        ->toHaveCount(3)
        ->toContain('pest');
});
EOF
    
    echo "🎉 Laravel project '$1' created successfully with Pest testing!"
    echo "📁 Location: ~/development/projects/$1"
    echo ""
    echo "🚀 Quick start:"
    echo "  cd ~/development/projects/$1"
    echo "  php artisan serve    # Start Laravel server"
    echo "  npm run dev          # Start Vite dev server"  
    echo "  php artisan test     # Run Pest tests"
    echo ""
    if [ "$2" = "react" ]; then
        echo "⚛️  React setup complete!"
        echo "  Edit resources/js/components/ for React components"
    fi
    echo "🎨 Tailwind CSS configured and ready"
    echo "🧪 Pest testing framework installed with sample tests"
}

# Quick development server startup
dev-start() {
    if [ -f "artisan" ]; then
        echo "Starting Laravel development server..."
        php artisan serve &
        LARAVEL_PID=$!
        
        if [ -f "package.json" ] && grep -q "vite" package.json; then
            echo "Starting Vite development server..."
            npm run dev &
            VITE_PID=$!
        fi
        
        echo "Development servers started!"
        echo "Laravel: http://localhost:8000"
        echo "Vite: http://localhost:5173"
        echo ""
        echo "Press Ctrl+C to stop all servers"
        
        trap "kill $LARAVEL_PID $VITE_PID 2>/dev/null" INT
        wait
    else
        echo "Not in a Laravel project directory"
    fi
}

# Claude Code integration helpers
claude-project() {
    echo "Opening current project in Claude Code..."
    claude .
}

claude-nvim() {
    if [ -n "$1" ]; then
        echo "Editing $1 with Claude Code, then opening in Neovim..."
        claude edit "$1"
        nvim "$1"
    else
        echo "Usage: claude-nvim filename"
    fi
}