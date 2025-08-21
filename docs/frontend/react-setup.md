# ⚛️  React + Laravel Development Guide

Complete guide to building modern frontends with React, TypeScript, and Tailwind CSS in Laravel projects.

## 🚀 Quick Start

```bash
# Create new project with React
laravel-new my-app react

# Start development servers
cd ~/development/projects/my-app
dev-start  # Starts Laravel + Vite
```

## 🏗️  Project Structure

```
resources/
├── js/
│   ├── components/          # Reusable React components
│   │   ├── UI/             # Basic UI components
│   │   ├── Forms/          # Form components
│   │   └── Layout/         # Layout components
│   ├── pages/              # Page components
│   ├── hooks/              # Custom React hooks
│   ├── utils/              # Utility functions
│   ├── types/              # TypeScript definitions
│   └── app.jsx             # Main application entry
├── css/
│   └── app.css             # Tailwind CSS imports
└── views/                  # Blade templates
```

## 🎨 Component Development

### React Functional Component
```jsx
// Type 'rfc' + Tab in Neovim for this template
import React from 'react';

interface PostCardProps {
  post: {
    id: number;
    title: string;
    excerpt: string;
    author: string;
    created_at: string;
  };
  onEdit?: (id: number) => void;
  onDelete?: (id: number) => void;
}

const PostCard: React.FC<PostCardProps> = ({ post, onEdit, onDelete }) => {
  return (
    <div className="bg-white rounded-lg shadow-md p-6 mb-4">
      <h3 className="text-xl font-semibold text-gray-900 mb-2">
        {post.title}
      </h3>
      <p className="text-gray-600 mb-4">
        {post.excerpt}
      </p>
      <div className="flex justify-between items-center">
        <span className="text-sm text-gray-500">
          By {post.author} • {new Date(post.created_at).toLocaleDateString()}
        </span>
        <div className="space-x-2">
          {onEdit && (
            <button
              onClick={() => onEdit(post.id)}
              className="px-3 py-1 text-blue-600 hover:bg-blue-50 rounded"
            >
              Edit
            </button>
          )}
          {onDelete && (
            <button
              onClick={() => onDelete(post.id)}
              className="px-3 py-1 text-red-600 hover:bg-red-50 rounded"
            >
              Delete
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default PostCard;
```

### Custom Hooks
```jsx
// hooks/useApi.js
import { useState, useEffect } from 'react';

function useApi(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(url)
      .then(response => response.json())
      .then(data => {
        setData(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err);
        setLoading(false);
      });
  }, [url]);

  return { data, loading, error };
}

export default useApi;

// Usage in component
const PostList = () => {
  const { data: posts, loading, error } = useApi('/api/posts');

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      {posts.map(post => (
        <PostCard key={post.id} post={post} />
      ))}
    </div>
  );
};
```

### Form Handling
```jsx
// components/Forms/PostForm.jsx
import React, { useState } from 'react';

interface PostFormProps {
  initialData?: {
    title: string;
    content: string;
  };
  onSubmit: (data: { title: string; content: string }) => void;
  loading?: boolean;
}

const PostForm: React.FC<PostFormProps> = ({ 
  initialData, 
  onSubmit, 
  loading = false 
}) => {
  const [formData, setFormData] = useState({
    title: initialData?.title || '',
    content: initialData?.content || '',
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Basic validation
    const newErrors: Record<string, string> = {};
    if (!formData.title.trim()) {
      newErrors.title = 'Title is required';
    }
    if (!formData.content.trim()) {
      newErrors.content = 'Content is required';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setErrors({});
    onSubmit(formData);
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="title" className="block text-sm font-medium text-gray-700">
          Title
        </label>
        <input
          type="text"
          id="title"
          value={formData.title}
          onChange={(e) => setFormData(prev => ({ ...prev, title: e.target.value }))}
          className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 ${
            errors.title ? 'border-red-500' : ''
          }`}
        />
        {errors.title && (
          <p className="mt-1 text-sm text-red-600">{errors.title}</p>
        )}
      </div>

      <div>
        <label htmlFor="content" className="block text-sm font-medium text-gray-700">
          Content
        </label>
        <textarea
          id="content"
          rows={6}
          value={formData.content}
          onChange={(e) => setFormData(prev => ({ ...prev, content: e.target.value }))}
          className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 ${
            errors.content ? 'border-red-500' : ''
          }`}
        />
        {errors.content && (
          <p className="mt-1 text-sm text-red-600">{errors.content}</p>
        )}
      </div>

      <button
        type="submit"
        disabled={loading}
        className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
      >
        {loading ? 'Saving...' : 'Save Post'}
      </button>
    </form>
  );
};

export default PostForm;
```

## 🎨 Tailwind CSS Integration

### Component Styling Patterns
```jsx
// Button Component with Tailwind variants
const Button = ({ variant = 'primary', size = 'md', children, ...props }) => {
  const baseClasses = 'inline-flex items-center justify-center font-medium rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors';
  
  const variants = {
    primary: 'bg-blue-600 hover:bg-blue-700 text-white focus:ring-blue-500',
    secondary: 'bg-gray-200 hover:bg-gray-300 text-gray-900 focus:ring-gray-500',
    danger: 'bg-red-600 hover:bg-red-700 text-white focus:ring-red-500',
  };
  
  const sizes = {
    sm: 'px-3 py-2 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg',
  };

  const classes = `${baseClasses} ${variants[variant]} ${sizes[size]}`;

  return (
    <button className={classes} {...props}>
      {children}
    </button>
  );
};

// Usage
<Button variant="primary" size="lg">
  Create Post
</Button>
```

### Responsive Design
```jsx
const ResponsiveGrid = ({ children }) => (
  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
    {children}
  </div>
);

const Card = ({ children }) => (
  <div className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
    {children}
  </div>
);
```

## 🔗 Laravel Integration

### API Routes (`routes/api.php`)
```php
<?php

use App\Http\Controllers\Api\PostController;
use App\Http\Controllers\Api\UserController;

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('posts', PostController::class);
    Route::get('user', [UserController::class, 'show']);
});
```

### API Controller
```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePostRequest;
use App\Http\Resources\PostResource;
use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        $posts = Post::with('user')->latest()->paginate(10);
        
        return PostResource::collection($posts);
    }

    public function store(StorePostRequest $request)
    {
        $post = $request->user()->posts()->create($request->validated());
        
        return new PostResource($post->load('user'));
    }

    public function show(Post $post)
    {
        return new PostResource($post->load('user'));
    }

    public function update(StorePostRequest $request, Post $post)
    {
        $this->authorize('update', $post);
        
        $post->update($request->validated());
        
        return new PostResource($post->load('user'));
    }

    public function destroy(Post $post)
    {
        $this->authorize('delete', $post);
        
        $post->delete();
        
        return response()->json(['message' => 'Post deleted successfully']);
    }
}
```

### API Resource
```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'content' => $this->content,
            'excerpt' => $this->excerpt,
            'status' => $this->status,
            'author' => [
                'id' => $this->user->id,
                'name' => $this->user->name,
            ],
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at->format('Y-m-d H:i:s'),
        ];
    }
}
```

### Inertia.js Integration (Optional)
```bash
# Install Inertia.js for SPA-like experience
composer require inertiajs/inertia-laravel
npm install @inertiajs/react
```

```jsx
// Using Inertia.js for seamless Laravel-React integration
import { Head, Link, useForm } from '@inertiajs/react';

const PostEdit = ({ post }) => {
  const { data, setData, put, processing, errors } = useForm({
    title: post.title,
    content: post.content,
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    put(route('posts.update', post.id));
  };

  return (
    <>
      <Head title={`Edit ${post.title}`} />
      
      <form onSubmit={handleSubmit}>
        <input
          value={data.title}
          onChange={e => setData('title', e.target.value)}
          className="..."
        />
        {errors.title && <div>{errors.title}</div>}
        
        <textarea
          value={data.content}
          onChange={e => setData('content', e.target.value)}
          className="..."
        />
        {errors.content && <div>{errors.content}</div>}
        
        <button type="submit" disabled={processing}>
          {processing ? 'Saving...' : 'Save'}
        </button>
      </form>
    </>
  );
};
```

## 🧪 Testing React Components

### Jest + React Testing Library
```jsx
// tests/javascript/components/PostCard.test.jsx
import { render, screen, fireEvent } from '@testing-library/react';
import PostCard from '../../../resources/js/components/PostCard';

const mockPost = {
  id: 1,
  title: 'Test Post',
  excerpt: 'This is a test post',
  author: 'John Doe',
  created_at: '2024-01-01T00:00:00Z'
};

describe('PostCard', () => {
  it('renders post information correctly', () => {
    render(<PostCard post={mockPost} />);
    
    expect(screen.getByText('Test Post')).toBeInTheDocument();
    expect(screen.getByText('This is a test post')).toBeInTheDocument();
    expect(screen.getByText('By John Doe')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', () => {
    const onEdit = jest.fn();
    render(<PostCard post={mockPost} onEdit={onEdit} />);
    
    fireEvent.click(screen.getByText('Edit'));
    
    expect(onEdit).toHaveBeenCalledWith(1);
  });
});
```

## 📱 Mobile Responsive Patterns

```jsx
// Mobile-first responsive component
const Navigation = ({ isOpen, setIsOpen }) => (
  <nav className="bg-white shadow-lg">
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div className="flex justify-between items-center h-16">
        {/* Logo */}
        <div className="flex-shrink-0">
          <img className="h-8 w-8" src="/logo.svg" alt="Logo" />
        </div>
        
        {/* Desktop Navigation */}
        <div className="hidden md:block">
          <div className="ml-10 flex items-baseline space-x-4">
            <Link href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md">
              Home
            </Link>
            <Link href="/posts" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md">
              Posts
            </Link>
          </div>
        </div>
        
        {/* Mobile menu button */}
        <div className="md:hidden">
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100"
          >
            <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    
    {/* Mobile Navigation */}
    {isOpen && (
      <div className="md:hidden">
        <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
          <Link href="/" className="text-gray-700 hover:text-blue-600 block px-3 py-2 rounded-md">
            Home
          </Link>
          <Link href="/posts" className="text-gray-700 hover:text-blue-600 block px-3 py-2 rounded-md">
            Posts
          </Link>
        </div>
      </div>
    )}
  </nav>
);
```

## ⚡ Performance Optimization

### Code Splitting
```jsx
import { lazy, Suspense } from 'react';

const PostEditor = lazy(() => import('./components/PostEditor'));

const App = () => (
  <div>
    <Suspense fallback={<div>Loading...</div>}>
      <PostEditor />
    </Suspense>
  </div>
);
```

### Memoization
```jsx
import { memo, useMemo, useCallback } from 'react';

const PostList = memo(({ posts, onPostClick }) => {
  const sortedPosts = useMemo(() => 
    posts.sort((a, b) => new Date(b.created_at) - new Date(a.created_at)),
    [posts]
  );

  const handlePostClick = useCallback((postId) => {
    onPostClick(postId);
  }, [onPostClick]);

  return (
    <div>
      {sortedPosts.map(post => (
        <PostCard 
          key={post.id} 
          post={post} 
          onClick={() => handlePostClick(post.id)}
        />
      ))}
    </div>
  );
});
```

## 🎯 Development Shortcuts

### Neovim Snippets
- `rfc` - React functional component
- `useState` - useState hook
- `useEffect` - useEffect hook
- `context` - React context setup

### Tailwind Snippets
- `btn` - Button with Tailwind classes
- `card` - Card component
- `grid` - Responsive grid
- `flex-center` - Centered flex container

### Development Commands
```bash
# Start development
npm run dev

# Build for production
npm run build

# Type checking
npm run type-check

# Linting
npm run lint
```

---

**Build beautiful, performant React applications integrated seamlessly with Laravel!** ⚛️✨