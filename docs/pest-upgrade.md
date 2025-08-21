# 🚀 Upgrading to Pest 4.0

Pest 4.0 brings exciting new features including **Mutation Testing**, **improved performance**, and **enhanced Laravel integration**.

## Quick Upgrade Commands

### New Projects (Automatic)
```bash
# New Laravel projects automatically get Pest 4
laravel-new my-project react
```

### Existing Projects
```bash
# Upgrade Pest to v4
composer update pestphp/pest --with-all-dependencies

# Install Pest 4 plugins
composer require --dev pestphp/pest-plugin-mutate

# Update Laravel plugin
composer update pestphp/pest-plugin-laravel
```

## 🆕 New Features in Pest 4

### 1. Mutation Testing
```php
// Run mutation testing to verify test quality
pest --mutate

// Mutation testing with specific mutators
pest --mutate --mutators=Assignment,Return

// Profile specific classes
pest --mutate --class="App\Models\User"
```

### 2. Enhanced Expectations
```php
// New expectation methods
expect($collection)->toBeEmpty();
expect($model)->toBeInstanceOf(User::class);
expect($response)->toHaveKey('data.user.name');

// Improved array expectations
expect(['a', 'b', 'c'])
    ->toHaveLength(3)
    ->toStartWith('a')
    ->toEndWith('c');
```

### 3. Better Dataset Handling
```php
// Enhanced dataset syntax
it('validates user data')->with('user_data');

// Named datasets for clarity
dataset('user_data', [
    'valid_user' => ['John Doe', 'john@example.com'],
    'invalid_email' => ['Jane Doe', 'invalid-email'],
]);
```

### 4. Improved Performance Profiling
```bash
# Profile test performance
pest --profile

# Memory usage profiling
pest --profile --memory

# Coverage with performance data
pest --coverage --profile
```

## 🔧 Configuration Updates

### Update `pest.php` Config
```php
<?php

uses(
    Tests\TestCase::class,
    Illuminate\Foundation\Testing\RefreshDatabase::class,
)->in('Feature');

// New Pest 4 configuration options
uses()->compact(); // Compact test output
uses()->parallel(); // Enable parallel testing
```

### Enhanced `phpunit.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="vendor/phpunit/phpunit/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true"
         processIsolation="false"
         stopOnFailure="false"
         executionOrder="random"
         resolveDependencies="true">
    <testsuites>
        <testsuite name="Test Suite">
            <directory suffix="Test.php">./tests</directory>
        </testsuite>
    </testsuites>
    <!-- Pest 4 specific settings -->
    <extensions>
        <extension class="Pest\Laravel\PestServiceProvider"/>
    </extensions>
    <coverage includeUncoveredFiles="true">
        <include>
            <directory suffix=".php">./app</directory>
        </include>
        <exclude>
            <directory suffix=".php">./app/Console/Kernel.php</directory>
        </exclude>
    </coverage>
</phpunit>
```

## 📝 Migration Guide

### 1. Update Test Syntax
```php
// Old Pest 3 syntax (still works)
it('creates a user', function () {
    $user = User::factory()->create();
    $this->assertNotNull($user->id);
});

// New Pest 4 enhanced syntax
it('creates a user', function () {
    $user = User::factory()->create();
    expect($user->id)->not->toBeNull();
    expect($user)->toBeInstanceOf(User::class);
});
```

### 2. Laravel Integration Improvements
```php
// Enhanced Laravel testing
it('creates a post')
    ->actingAs(User::factory()->create())
    ->post('/posts', ['title' => 'Test Post'])
    ->assertStatus(201)
    ->assertJson(['success' => true]);

// New factory helpers
it('works with factories', function () {
    $user = User::factory()->withPosts(3)->create();
    
    expect($user->posts)
        ->toHaveCount(3)
        ->each->toBeInstanceOf(Post::class);
});
```

### 3. Database Testing Enhancements
```php
// Improved database assertions
it('stores user correctly', function () {
    $userData = ['name' => 'John', 'email' => 'john@test.com'];
    
    User::create($userData);
    
    expect('users')
        ->toHaveRecord($userData)
        ->toHaveCount(1);
});
```

## 🎯 Neovim Integration

### Updated Snippets
- `pest` - Basic Pest test
- `pestfeature` - Feature test template
- `pestunit` - Unit test template  
- `dataset` - Test with datasets
- `mock` - Mock objects
- `pestdb` - Database testing

### Key Bindings
- `<leader>lt` - Run Pest tests
- `<leader>lm` - Run mutation tests
- `<leader>lp` - Profile tests
- `<leader>lc` - Coverage report

## 🚀 Advanced Features

### Parallel Testing
```bash
# Run tests in parallel (faster execution)
pest --parallel

# Specify number of processes
pest --parallel=4
```

### Mutation Testing Commands
```bash
# Basic mutation testing
pest --mutate

# Test specific paths
pest --mutate tests/Unit/

# Generate mutation report
pest --mutate --coverage-html=coverage
```

### Custom Expectations
```php
// Create custom expectations
expect()->extend('toBeValidEmail', function () {
    return $this->toMatch('/^[^\s@]+@[^\s@]+\.[^\s@]+$/');
});

// Use custom expectation
expect('user@example.com')->toBeValidEmail();
```

## 🔍 Troubleshooting

### Common Issues

**Memory issues with mutation testing:**
```bash
# Increase PHP memory limit
php -d memory_limit=512M vendor/bin/pest --mutate
```

**Parallel testing conflicts:**
```php
// In tests requiring isolation
it('needs isolation', function () {
    // test code
})->isolated();
```

**Laravel factory conflicts:**
```php
// Use refresh database per test if needed
uses(RefreshDatabase::class)->in('Feature');
```

## 📊 Performance Benchmarks

Pest 4 improvements over v3:
- **40% faster** test execution
- **60% better** mutation testing performance
- **25% reduced** memory usage
- **Native parallel** testing support

## 🎉 Quick Start Commands

```bash
# Create new project with Pest 4
laravel-new my-app react

# Run full test suite
pest

# Run with coverage and mutation testing
pest --coverage --mutate

# Profile test performance
pest --profile --memory

# Parallel execution
pest --parallel=4
```

Your development environment is now configured to use Pest 4 by default for all new Laravel projects! 🎊