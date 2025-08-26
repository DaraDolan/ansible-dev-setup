# Authentication & Permissions Setup

## 🎯 Goal
Set up Laravel authentication with Spatie permissions for our portfolio management system.

## 🔧 What We'll Build
- User authentication with different roles
- Permission-based access control  
- Admin, Manager, and Investor roles
- Database structure for portfolios and users

## 📦 Install Required Packages

```bash
# Install Spatie Laravel Permission
composer require spatie/laravel-permission

# Publish the migration
php artisan vendor:publish --provider="Spatie\Permission\PermissionServiceProvider"

# Install Laravel Breeze for authentication (if not included)
composer require laravel/breeze --dev
php artisan breeze:install react
```

**🎮 Neovim Tip**: Use `<leader>tt` to open terminal in new tab for running commands.

## 🗄️ Database Setup

### 1. Run Permission Migrations

```bash
php artisan migrate
```

This creates tables for:
- `permissions`
- `roles` 
- `model_has_permissions`
- `model_has_roles`
- `role_has_permissions`

### 2. Create Additional Migrations

**🎮 Neovim Workflow**:
1. Press `<leader>f` to find files
2. Navigate to `database/migrations/`
3. Use `migration` snippet for each migration

**Portfolio Migration**:
```bash
php artisan make:migration create_portfolios_table
```

**Stock Migration**:
```bash
php artisan make:migration create_stocks_table
```

**Transaction Migration**:
```bash
php artisan make:migration create_transactions_table
```

### 3. Define Migration Schemas

**🎮 Neovim**: Open migration files and use the `migration` snippet:

**Portfolios Migration**:
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('portfolios', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('manager_id')->nullable()->constrained('users');
            $table->decimal('initial_value', 15, 2)->default(0);
            $table->decimal('current_value', 15, 2)->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('portfolios');
    }
};
```

**Stocks Migration**:
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('stocks', function (Blueprint $table) {
            $table->id();
            $table->string('symbol')->unique();
            $table->string('name');
            $table->string('exchange');
            $table->decimal('current_price', 10, 4)->nullable();
            $table->timestamp('last_updated')->nullable();
            $table->timestamps();
            
            $table->index('symbol');
        });
    }

    public function down()
    {
        Schema::dropIfExists('stocks');
    }
};
```

**Transactions Migration**:
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('portfolio_id')->constrained()->onDelete('cascade');
            $table->foreignId('stock_id')->constrained()->onDelete('cascade');
            $table->enum('type', ['buy', 'sell']);
            $table->integer('quantity');
            $table->decimal('price_per_share', 10, 4);
            $table->decimal('total_amount', 15, 2);
            $table->decimal('fees', 8, 2)->default(0);
            $table->enum('status', ['pending', 'executed', 'cancelled'])->default('pending');
            $table->timestamp('executed_at')->nullable();
            $table->timestamps();
            
            $table->index(['portfolio_id', 'created_at']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('transactions');
    }
};
```

### 4. Run Migrations

```bash
php artisan migrate
```

## 👤 User Model Setup

**🎮 Neovim**: Open `app/Models/User.php` (`<leader>f` → type `User.php`)

Update the User model:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasRoles;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // Relationships
    public function ownedPortfolios()
    {
        return $this->hasMany(Portfolio::class, 'user_id');
    }

    public function managedPortfolios()
    {
        return $this->hasMany(Portfolio::class, 'manager_id');
    }

    // Helper methods
    public function isAdmin()
    {
        return $this->hasRole('admin');
    }

    public function isManager()
    {
        return $this->hasRole('manager');
    }

    public function isInvestor()
    {
        return $this->hasRole('investor');
    }
}
```

## 🏗️ Create Models

**🎮 Neovim Shortcuts**:
- Use `<leader>lm` to quickly run `php artisan make:model`
- Or use terminal: `<C-\>` for floating terminal

```bash
php artisan make:model Portfolio
php artisan make:model Stock  
php artisan make:model Transaction
```

### Portfolio Model

**🎮 Neovim**: Open `app/Models/Portfolio.php` and use `model` snippet:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Portfolio extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'user_id',
        'manager_id',
        'initial_value',
        'current_value',
        'is_active'
    ];

    protected function casts(): array
    {
        return [
            'initial_value' => 'decimal:2',
            'current_value' => 'decimal:2',
            'is_active' => 'boolean',
        ];
    }

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function manager()
    {
        return $this->belongsTo(User::class, 'manager_id');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    // Helper methods
    public function calculateValue()
    {
        // Will implement this later with stock prices
        return $this->transactions()
            ->where('status', 'executed')
            ->sum('total_amount');
    }
}
```

### Stock and Transaction Models

**Stock Model** (`app/Models/Stock.php`):
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    use HasFactory;

    protected $fillable = [
        'symbol',
        'name',
        'exchange',
        'current_price',
        'last_updated'
    ];

    protected function casts(): array
    {
        return [
            'current_price' => 'decimal:4',
            'last_updated' => 'datetime',
        ];
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }
}
```

**Transaction Model** (`app/Models/Transaction.php`):
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'portfolio_id',
        'stock_id',
        'type',
        'quantity',
        'price_per_share',
        'total_amount',
        'fees',
        'status',
        'executed_at'
    ];

    protected function casts(): array
    {
        return [
            'quantity' => 'integer',
            'price_per_share' => 'decimal:4',
            'total_amount' => 'decimal:2',
            'fees' => 'decimal:2',
            'executed_at' => 'datetime',
        ];
    }

    public function portfolio()
    {
        return $this->belongsTo(Portfolio::class);
    }

    public function stock()
    {
        return $this->belongsTo(Stock::class);
    }
}
```

## 🔐 Permissions & Roles Setup

### 1. Create Database Seeder

```bash
php artisan make:seeder RolePermissionSeeder
```

**🎮 Neovim**: Open `database/seeders/RolePermissionSeeder.php`:

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use App\Models\User;

class RolePermissionSeeder extends Seeder
{
    public function run()
    {
        // Create Permissions
        $permissions = [
            // User management
            'manage-users',
            'view-users',
            
            // Portfolio management
            'create-portfolios',
            'view-own-portfolios',
            'view-all-portfolios',
            'manage-portfolios',
            
            // Transaction management
            'create-transactions',
            'approve-transactions',
            'view-own-transactions',
            'view-all-transactions',
            
            // Stock management
            'manage-stocks',
            'view-stocks',
            
            // Reports
            'view-reports',
            'generate-reports',
        ];

        foreach ($permissions as $permission) {
            Permission::create(['name' => $permission]);
        }

        // Create Roles
        $adminRole = Role::create(['name' => 'admin']);
        $managerRole = Role::create(['name' => 'manager']);
        $investorRole = Role::create(['name' => 'investor']);

        // Assign Permissions to Roles
        $adminRole->givePermissionTo(Permission::all());
        
        $managerRole->givePermissionTo([
            'view-users',
            'view-all-portfolios',
            'manage-portfolios',
            'create-transactions',
            'approve-transactions',
            'view-all-transactions',
            'view-stocks',
            'view-reports',
            'generate-reports',
        ]);

        $investorRole->givePermissionTo([
            'view-own-portfolios',
            'create-transactions',
            'view-own-transactions',
            'view-stocks',
            'view-reports',
        ]);

        // Create admin user
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@portfolio.com',
            'password' => bcrypt('password123'),
        ]);
        $admin->assignRole('admin');

        // Create test manager
        $manager = User::create([
            'name' => 'Portfolio Manager',
            'email' => 'manager@portfolio.com',
            'password' => bcrypt('password123'),
        ]);
        $manager->assignRole('manager');

        // Create test investor
        $investor = User::create([
            'name' => 'Test Investor',
            'email' => 'investor@portfolio.com',
            'password' => bcrypt('password123'),
        ]);
        $investor->assignRole('investor');
    }
}
```

### 2. Update DatabaseSeeder

**🎮 Neovim**: Open `database/seeders/DatabaseSeeder.php`:

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            RolePermissionSeeder::class,
        ]);
    }
}
```

### 3. Run the Seeders

```bash
php artisan db:seed
```

## 🧪 Test Authentication

### 1. Create Test Route

**🎮 Neovim**: Open `routes/web.php` (`<leader>f` → type `web.php`):

```php
<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome');
});

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/dashboard', function () {
        return Inertia::render('Dashboard', [
            'user' => auth()->user()->load('roles', 'permissions'),
            'roles' => auth()->user()->getRoleNames(),
            'permissions' => auth()->user()->getAllPermissions()->pluck('name'),
        ]);
    })->name('dashboard');
});

require __DIR__.'/auth.php';
```

### 2. Test Login

Start your servers:
```bash
# Terminal 1
php artisan serve

# Terminal 2  
npm run dev
```

Visit `http://localhost:8000` and:
1. Register a new account
2. Login with test accounts:
   - **Admin**: admin@portfolio.com / password123
   - **Manager**: manager@portfolio.com / password123
   - **Investor**: investor@portfolio.com / password123

## ✅ Success Criteria

You should have:
- ✅ Authentication working with Laravel Breeze
- ✅ Spatie permissions installed and configured
- ✅ User roles: Admin, Manager, Investor
- ✅ Database tables for portfolios, stocks, transactions
- ✅ Test users created with different roles
- ✅ Permission-based access control ready

## 🎮 Neovim Mastery Checkpoint

Shortcuts you should have used:
- ✅ `<leader>f` for file finding
- ✅ `migration` snippet for migrations
- ✅ `model` snippet for models  
- ✅ `<C-\>` for terminal
- ✅ `<leader>gg` for Git operations

## 🎯 Next Steps

Authentication and permissions are ready! Proceed to:
**[03-models-relationships.md](./03-models-relationships.md)** - Build the core business logic

Your foundation is rock solid! 🚀