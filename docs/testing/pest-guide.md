# 🧪 Pest Testing Guide

Complete guide to test-driven development with Pest 4 in Laravel projects.

## 🚀 Quick Start

```bash
# Run all tests
pest

# Watch mode (auto-run on changes)
pest --watch

# Coverage report
pest --coverage

# Mutation testing (Pest 4 feature)
pest --mutate
```

## 📋 Test Structure

### Feature Tests (`tests/Feature/`)
Test your application from the user's perspective:

```php
<?php

use App\Models\User;

it('allows users to create posts', function () {
    $user = User::factory()->create();
    
    $this->actingAs($user)
         ->post('/posts', [
             'title' => 'My First Post',
             'content' => 'This is the content'
         ])
         ->assertStatus(201)
         ->assertJson(['message' => 'Post created successfully']);
         
    expect('posts')->toHaveRecord([
        'title' => 'My First Post',
        'user_id' => $user->id
    ]);
});
```

### Unit Tests (`tests/Unit/`)
Test individual classes and methods:

```php
<?php

use App\Services\PostService;
use App\Models\Post;

it('formats post excerpts correctly', function () {
    $service = new PostService();
    $post = Post::factory()->make([
        'content' => 'This is a very long post content that should be truncated.'
    ]);
    
    $excerpt = $service->getExcerpt($post, 10);
    
    expect($excerpt)
        ->toHaveLength(10)
        ->toEndWith('...');
});
```

## 🎯 Pest Syntax Patterns

### Basic Test Structure
```php
it('describes what the test does', function () {
    // Arrange
    $user = User::factory()->create();
    
    // Act
    $result = $user->getDisplayName();
    
    // Assert
    expect($result)->toBe($user->name);
});
```

### Using Datasets
```php
it('validates email addresses', function (string $email, bool $isValid) {
    $validator = new EmailValidator();
    
    expect($validator->isValid($email))->toBe($isValid);
})->with([
    ['user@example.com', true],
    ['invalid-email', false],
    ['test@test.co.uk', true],
    ['@example.com', false],
]);
```

### Grouped Tests
```php
describe('UserService', function () {
    beforeEach(function () {
        $this->service = new UserService();
        $this->user = User::factory()->create();
    });
    
    it('can update user profile', function () {
        $this->service->updateProfile($this->user, ['name' => 'New Name']);
        
        expect($this->user->fresh()->name)->toBe('New Name');
    });
    
    it('validates required fields', function () {
        expect(fn() => $this->service->updateProfile($this->user, []))
            ->toThrow(ValidationException::class);
    });
});
```

## 🔬 Advanced Expectations

### Collection Expectations
```php
it('returns correct post collection', function () {
    $posts = Post::factory()->count(3)->create();
    
    $collection = PostService::getPublishedPosts();
    
    expect($collection)
        ->toHaveCount(3)
        ->each->toBeInstanceOf(Post::class)
        ->first()->title->not->toBeEmpty();
});
```

### Custom Expectations
```php
// In tests/Pest.php or a helper file
expect()->extend('toBeValidEmail', function () {
    $pattern = '/^[^\s@]+@[^\s@]+\.[^\s@]+$/';
    
    expect($this->value)->toMatch($pattern);
    
    return $this;
});

// Usage in tests
it('validates email format', function () {
    expect('user@example.com')->toBeValidEmail();
});
```

### Database Expectations
```php
it('stores user data correctly', function () {
    $userData = [
        'name' => 'John Doe',
        'email' => 'john@example.com'
    ];
    
    User::create($userData);
    
    expect('users')
        ->toHaveRecord($userData)
        ->toHaveCount(1);
});
```

## 🏗️  Laravel Testing Patterns

### HTTP Testing
```php
it('requires authentication for protected routes', function () {
    $this->get('/dashboard')
         ->assertStatus(302)
         ->assertRedirect('/login');
});

it('shows user dashboard when authenticated', function () {
    $user = User::factory()->create();
    
    $this->actingAs($user)
         ->get('/dashboard')
         ->assertStatus(200)
         ->assertSee('Welcome, ' . $user->name);
});
```

### API Testing
```php
it('returns JSON response for API endpoints', function () {
    $user = User::factory()->create();
    
    $this->postJson('/api/posts', [
        'title' => 'API Post',
        'content' => 'Content via API'
    ], [
        'Authorization' => 'Bearer ' . $user->createToken('test')->plainTextToken
    ])
    ->assertStatus(201)
    ->assertJsonStructure([
        'data' => [
            'id',
            'title',
            'content',
            'created_at'
        ]
    ]);
});
```

### Database Testing
```php
it('creates associated records correctly', function () {
    $user = User::factory()
        ->has(Post::factory()->count(3))
        ->create();
    
    expect($user->posts)
        ->toHaveCount(3)
        ->each->user_id->toBe($user->id);
});

it('handles soft deletes', function () {
    $post = Post::factory()->create();
    
    $post->delete();
    
    expect($post->trashed())->toBeTrue();
    expect(Post::withTrashed()->count())->toBe(1);
    expect(Post::count())->toBe(0);
});
```

## 🎭 Mocking & Fakes

### Service Mocking
```php
it('sends notification when post is published', function () {
    $notificationService = $this->mock(NotificationService::class);
    $notificationService->shouldReceive('send')
                       ->once()
                       ->with(Mockery::type(User::class), 'post_published');
    
    $post = Post::factory()->create(['status' => 'draft']);
    
    $post->publish();
});
```

### Queue Testing
```php
it('dispatches job when user registers', function () {
    Queue::fake();
    
    $user = User::factory()->create();
    
    Queue::assertPushed(SendWelcomeEmail::class, function ($job) use ($user) {
        return $job->user->id === $user->id;
    });
});
```

### Mail Testing
```php
it('sends welcome email on registration', function () {
    Mail::fake();
    
    User::factory()->create(['email' => 'test@example.com']);
    
    Mail::assertSent(WelcomeEmail::class, function ($mail) {
        return $mail->hasTo('test@example.com');
    });
});
```

## 🚀 Pest 4 Features

### Mutation Testing
```bash
# Run mutation testing to verify test quality
pest --mutate

# Test specific classes
pest --mutate --class="App\Models\User"

# Use specific mutators
pest --mutate --mutators=Assignment,Return
```

### Parallel Testing
```bash
# Run tests in parallel for faster execution
pest --parallel

# Specify number of processes
pest --parallel=4
```

### Enhanced Profiling
```bash
# Profile test performance
pest --profile

# Memory profiling
pest --profile --memory

# Combined coverage and profiling
pest --coverage --profile
```

## ⌨️  Neovim Integration

### Shortcuts
- `<leader>tn` - Run test under cursor
- `<leader>tf` - Run current test file
- `<leader>ts` - Run entire test suite
- `<leader>tl` - Re-run last test

### Snippets
- `pest` - Basic test
- `pestfeature` - Feature test template
- `pestunit` - Unit test template
- `dataset` - Test with datasets
- `expect` - Expectation
- `mock` - Mock object
- `pestdb` - Database test

## 📊 Coverage & Quality

### Coverage Reports
```bash
# HTML coverage report
pest --coverage --coverage-html=coverage

# Text coverage summary
pest --coverage --coverage-text

# Minimum coverage threshold
pest --coverage --min=80
```

### Code Quality Integration
```bash
# Run with PHPStan
vendor/bin/phpstan analyse && pest

# Run with PHP CS Fixer
vendor/bin/php-cs-fixer fix && pest

# Complete quality check
composer run quality && pest --coverage
```

## 🛠️ Configuration

### `pest.php` Setup
```php
<?php

uses(
    Tests\TestCase::class,
    Illuminate\Foundation\Testing\RefreshDatabase::class,
)->in('Feature');

uses(Tests\TestCase::class)->in('Unit');

// Custom functions available in all tests
function createUser(array $attributes = []): User
{
    return User::factory()->create($attributes);
}

function actingAsUser(array $attributes = []): TestCase
{
    return test()->actingAs(createUser($attributes));
}
```

### PHPUnit Integration
```xml
<!-- phpunit.xml -->
<phpunit bootstrap="vendor/autoload.php">
    <testsuites>
        <testsuite name="Feature">
            <directory suffix="Test.php">./tests/Feature</directory>
        </testsuite>
        <testsuite name="Unit">
            <directory suffix="Test.php">./tests/Unit</directory>
        </testsuite>
    </testsuites>
    <coverage includeUncoveredFiles="true">
        <include>
            <directory suffix=".php">./app</directory>
        </include>
    </coverage>
</phpunit>
```

## 🎯 Best Practices

1. **Descriptive Names**: Use `it('can do something')` format
2. **One Assertion**: Focus each test on one behavior
3. **AAA Pattern**: Arrange, Act, Assert
4. **Use Factories**: Leverage model factories for test data
5. **Test Edge Cases**: Don't just test the happy path
6. **Mock External Services**: Isolate your application logic
7. **Database Isolation**: Use `RefreshDatabase` trait

## 📚 Resources

- [Pest Documentation](https://pestphp.com/)
- [Laravel Testing](https://laravel.com/docs/testing)
- [🚀 Pest 4 Upgrade Guide](../pest-upgrade.md)

---

**Write tests. Write good tests. Write fast tests.** 🧪✨