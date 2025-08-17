# Big Bang - Rails 8 Template

A modern Rails 8 template with ActiveAdmin 4, Tailwind CSS, and Vue.js 3. Perfect for building admin-heavy applications with a modern frontend.

## 🚀 Features

- **Rails 8.0.2** - Latest Rails with modern defaults
- **ActiveAdmin 4 beta15** - Admin interface with Tailwind CSS styling
- **Vue.js 3** - Modern JavaScript framework ready to use
- **Tailwind CSS** - Utility-first CSS framework
- **PostgreSQL** - Production-ready database
- **RuboCop** - Code linting with single quotes preference
- **Sprockets** - Traditional asset pipeline (no webpacker)
- **Devise** - Authentication for ActiveAdmin

## 📋 Prerequisites

- Ruby 3.2.2 or higher
- PostgreSQL
- Node.js (for Tailwind compilation)
- Yarn (for package management)

## 🛠️ Installation

1. **Clone the template:**
   ```bash
   git clone https://github.com/griffero/big-bang.git your-project-name
   cd your-project-name
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Setup database:**
   ```bash
   rails db:create db:migrate
   ```

4. **Create admin user:**
   ```bash
   rails db:seed
   ```
   Default admin credentials:
   - Email: `admin@example.com`
   - Password: `password`

5. **Start the server:**
   ```bash
   rails server
   ```

## 🌐 Access Points

- **Main Application**: http://localhost:3000
- **ActiveAdmin**: http://localhost:3000/admin

## 🎨 Customization

### ActiveAdmin Styling

The template includes a custom `_html_head.html.erb` partial for ActiveAdmin that loads Tailwind CSS. This ensures ActiveAdmin components are styled with Tailwind classes.

### Vue.js Setup

Vue.js is configured to work with Rails' asset pipeline. The main Vue app is mounted in `app/views/layouts/application.html.erb`.

### Tailwind Configuration

Tailwind is configured with ActiveAdmin plugin support in `config/tailwind.config.js`. It includes all necessary paths for ActiveAdmin components.

## 🔧 Development

### Code Style

The project uses RuboCop with custom rules:
- Single quotes for strings
- Trailing commas in multiline arrays/hashes
- Guard clauses enabled
- Compact spacing in blocks

Run the linter:
```bash
bundle exec rubocop
```

Auto-correct issues:
```bash
bundle exec rubocop --autocorrect
```

### Asset Compilation

Compile Tailwind CSS:
```bash
rails tailwindcss:build
```

Watch for changes:
```bash
rails tailwindcss:watch
```

## 📁 Project Structure

```
├── app/
│   ├── admin/                 # ActiveAdmin resources
│   ├── assets/
│   │   ├── stylesheets/       # CSS files
│   │   └── javascripts/       # JavaScript files
│   ├── views/
│   │   ├── active_admin/      # ActiveAdmin custom views
│   │   └── layouts/           # Application layouts
│   └── javascript/            # Vue.js components
├── config/
│   ├── tailwind.config.js     # Tailwind configuration
│   └── importmap.rb          # JavaScript dependencies
└── db/
    └── seeds.rb              # Admin user creation
```

## 🚀 Deployment

This template is ready for deployment with:
- **Kamal** - Modern Rails deployment
- **Docker** - Containerization support
- **PostgreSQL** - Production database

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## 📄 License

This template is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Rails team for the amazing framework
- ActiveAdmin team for the admin interface
- Tailwind CSS team for the utility-first approach
- Vue.js team for the reactive framework
