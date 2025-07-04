# Git Info Terminal - AppleScript Project Information Tool

An AppleScript that provides instant project information and development environment details directly in Terminal by right-clicking on any project folder in Finder.

## 🚀 Features

- **One-click project analysis** - Right-click any folder in Finder to get instant project information
- **Multi-framework support** - Detects and provides information for:
  - 📁 Git repositories
  - 🚀 Laravel projects
  - 📱 Ionic Angular projects
  - ⚛️ React projects
  - 🟢 Vue.js projects
  - ☕ Java Spring Boot projects (Maven & Gradle)
  - 🐍 Python projects (Django support)
- **Development environment info** - Shows installed versions of tools and runtimes
- **Common commands** - Displays frequently used commands for each detected framework
- **Smart Terminal integration** - Opens in new tab if Terminal is already running

## 📋 What Information Does It Show?

### Git Repository Information
- Current branch name
- Remote repository URL
- Last commit details (hash, message, author, date)
- Commit timestamp

### Framework-Specific Information
- **Laravel**: PHP, Laravel, and Composer versions + common artisan commands
- **Ionic Angular**: Node, NPM, Ionic, and Angular versions + ionic commands
- **React**: Node, NPM, and React versions + npm commands
- **Vue**: Node, NPM, and Vue versions + npm commands
- **Java Spring Boot**: Java version, build tool (Maven/Gradle), Spring Boot version + build commands
- **Python/Django**: Python version, dependencies info + Django management commands

## 🛠 Installation

### Method 1: Download and Install
1. Download the `Git Info Terminal.scpt` file
2. Double-click to open in Script Editor
3. Save as Application (.app) or keep as Script (.scpt)
4. Move to your Applications folder or desired location

### Method 2: Create from Source
1. Open **Script Editor** on your Mac
2. Copy and paste the script content
3. Save as "Git Info Terminal" with file format "Script" (.scpt)

### Method 3: Automator Service (Recommended)
1. Open **Automator**
2. Create a new **Quick Action** (Service)
3. Set "Workflow receives current" to **folders** in **Finder**
4. Add "Run AppleScript" action
5. Paste the script content
6. Save with a descriptive name like "Get Project Info"

## 📱 Usage

### If saved as Application:
1. Select a project folder in Finder
2. Run the Git Info Terminal application
3. View project information in Terminal

### If created as Automator Service:
1. Right-click on any folder in Finder
2. Select "Get Project Info" from the Services menu
3. View project information in Terminal

### Direct Script Execution:
1. Open Script Editor
2. Open the saved script
3. Select a folder in Finder
4. Click "Run" in Script Editor

## 🔧 Requirements

- macOS with AppleScript support
- Terminal application
- Git (optional, for git repository information)
- Relevant development tools for framework detection:
  - PHP & Composer (for Laravel)
  - Node.js & NPM (for React, Vue, Ionic)
  - Java & Maven/Gradle (for Spring Boot)
  - Python (for Django)

## 📝 Example Output

```
=== PROJECT INFORMATION ===

📁 GIT REPOSITORY INFO:
Branch: main
Repo: https://github.com/username/my-project.git
Last Commit: a1b2c3d - Add new feature (John Doe, 2 hours ago)
Commit Date: 2025-07-04 10:30:25 +0000

🚀 LARAVEL PROJECT DETECTED:
PHP Version: 8.2.0
Laravel Version: 10.0
Composer Version: 2.5.1

📦 Laravel Commands:
  Start: php artisan serve
  Install: composer install
  Migration: php artisan migrate

==========================
```

## 🐛 Troubleshooting

### Script doesn't run:
- Ensure you have selected a folder in Finder before running
- Check that Terminal has necessary permissions
- Verify Script Editor has accessibility permissions if needed

### No project information shown:
- The script looks for specific files (package.json, composer.json, etc.)
- Ensure you're running it on actual project folders
- Some frameworks require specific files to be detected

### Version information shows "Not installed":
- Install the relevant development tools for your project type
- Ensure tools are in your system PATH
- Restart Terminal after installing new tools

## 🤝 Contributing

Feel free to contribute by:
- Adding support for additional frameworks
- Improving existing detection logic
- Enhancing the output format
- Fixing bugs or improving error handling

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Built for macOS developers who work with multiple project types
- Inspired by the need for quick project context switching
- Supports the most common web and mobile development frameworks

---

**Note**: This script is designed to work with macOS and requires AppleScript support. It integrates seamlessly with Finder and Terminal for the best user experience.
