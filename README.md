# Enjin - Portable Multi-PHP & MySQL Development Environment for Windows
![Project Banner](assets/banner.png)



## Overview

**Enjin** is a portable, lightweight, and versatile Windows development environment for PHP developers. It allows you to run multiple **PHP versions** simultaneously and manage multiple projects with ease. With built-in support for **portable MySQL and MariaDB**, Enjin ensures a clean, isolated workflow without requiring system-wide installation of PHP or databases.

Enjin is perfect for:

- Testing and running projects across different PHP versions (PHP 7.4, 8.0, 8.1, etc.)
- Managing legacy and modern PHP applications side by side
- Portable development on USB drives or external disks
- Avoiding conflicts with globally installed PHP or database stacks

**Keywords**: portable PHP server, multiple PHP versions, portable MySQL, Windows PHP development, Enjin portable server, PHP project environment

---

## Folder Structure

Enjin uses a simple and predictable folder layout for portability and SEO-friendly documentation clarity:

```
G:\portable_server\
│
├─ php\
│  ├─ php81\
│  │  ├─ php.exe
│  │  └─ ext\
│  ├─ php82\
│  └─ ...
│
├─ root\            (project folders created here)
│
├─ database\        (portable MySQL/MariaDB folders per version)
│  ├─ mysql57\
│  ├─ mysql80\
│  └─ ...
├─ create_project.bat
└─ config.ini
```

**Keywords**: portable PHP directory structure, Enjin folder structure, PHP and MySQL setup, Windows development folder

---

## Requirements

- Windows 10 or newer
- Portable PHP builds in `php` folder
- Portable MySQL or MariaDB (optional for database support)
- Write permission to the portable server directory

---

## Configuration File (`config.ini`)

Example `config.ini`:

```
SERVER_ROOT=G:\portable_server\
SERVER_DOC_ROOT=G:\portable_server\root
DEFAULT_HOST=localhost
DEFAULT_PORT=8000
```

**SEO keywords**: Enjin config, portable PHP config, PHP project config, config.ini setup

---

## How Enjin Works

Enjin allows manual project management and PHP version selection for maximum control:

- Choose your PHP version per project
- Assign a unique port for each project
- Start servers manually for isolated environments

**Keywords**: run multiple PHP versions, Enjin PHP workflow, PHP version management, manual project setup

---

## Creating a New Project (Manual Workflow)

1. Create a new folder inside the document root.
2. Add your PHP files (e.g., `index.php`).
3. Choose the PHP version to run.
4. Start the PHP built-in server manually using the selected PHP executable.

Each project can run independently on different PHP versions and ports.

**Keywords**: PHP project setup, Enjin project workflow, portable PHP server, multiple PHP projects

---

## MySQL / MariaDB Installation and Setup (Portable)

Step-by-step guide to install and run portable MySQL or MariaDB for Enjin:

### Step 1: Download

- Download the ZIP or portable version from the official MariaDB or MySQL site (avoid installers).

### Step 2: Extract

- Extract each version into its own folder:

```
G:\portable_server\mysql\mysql57\
G:\portable_server\mysql\mysql80\
```

### Step 3: Create Data Directory

```
G:\portable_server\mysql\mysql57\data
G:\portable_server\mysql\mysql80\data
```

### Step 4: Initialize Database

- Open **Windows PowerShell** as Administrator.
- Navigate to the `bin` folder of the database version:

```
cd G:\portable_server\mysql\mysql57\bin
```

- Initialize database using full path:

```
.\"G:\portable_server\mysql\mysql57\bin\mysqld.exe" --initialize-insecure --datadir="G:\portable_server\mysql\mysql57\data"
```

### Step 5: Start Database Server

- Start server manually:

```
.\"G:\portable_server\mysql\mysql57\bin\mysqld.exe" --datadir="G:\portable_server\mysql\mysql57\data"
```

- Optional: create `start_db.bat` for convenience.

### Step 6: Connect PHP Projects

```php
$host = '127.0.0.1';
$port = 3306;
$username = 'root';
$password = '';
$dbname = 'my_project_db';
```

**Keywords**: portable MySQL setup, Enjin MySQL, MariaDB setup Windows, PHP database connection, PHP MySQL tutorial

---

## Generated Files

### index.php

```
<?php
echo "Project is running";
?>
```

### run.bat

- Sets the correct PHP directory
- Loads extensions from the selected PHP version
- Starts PHP using `php -S`

**Keywords**: PHP development server, run PHP project, Enjin index.php, run.bat instructions

---

## Support and Donations

### Paid Support

Professional support available for:

- Enjin setup and customization
- Multi-PHP project workflows
- Portable MySQL / MariaDB configuration
- Troubleshooting environments

## Demo Video
-- 
[Watch the video on YouTube](https://www.youtube.com/watch?v=iyH5ek-Asv4)

Contact:
- Email: archivetuhin@gmail.com
- WhatsApp: +8801837742506

### Donations

- PayPal: https://paypal.me/myappclours

**Keywords**: Enjin support, Enjin donations, professional PHP help, portable PHP support

---

## Best Practices

- Keep PHP versions clearly named (php81, php82, etc.)
- Keep database versions clearly named (mysql57, mysql80, etc.)
- Do not move project folders after creation
- Run everything from the portable server directory
- Use separate database instances per project if needed

**Keywords**: PHP best practices, database best practices, Enjin tips, portable server guidelines

---

## License

This script is provided as-is for local development and learning purposes. You are free to modify and redistribute it within your own projects.

**Keywords**: Enjin license, portable PHP license, open source PHP server

