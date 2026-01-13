# <p align="center">Enjin</p>
<p align="center"><img src="https://i.postimg.cc/4dhtMG8V/Chat-GPT-Image-Jan-13-2026-09-16-07-AM.png" alt="Enjin Logo" width="120"></p>

<p align="center">
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)]
[![PHP Versions](https://img.shields.io/badge/PHP-7.4%7C8.0%7C8.1-lightgrey.svg)]
[![MySQL](https://img.shields.io/badge/MySQL-5.7%7C8.0-blue.svg)]
[![Frameworks](https://img.shields.io/badge/Frameworks-Laravel%2CCodeIgniter-green.svg)]
</p>

---

## 📖 Table of Contents
1. [About](#about)
2. [Demo](#demo)
3. [Features](#features)
4. [Folder Structure](#folder-structure)
5. [Quick Start](#quick-start)
6. [Configuration](#configuration)
7. [Advanced Configuration](#advanced-configuration)
8. [Sponsorship & Donations](#sponsorship--donations)
9. [Hire Me](#hire-me)
10. [Support & Contact](#support--contact)
11. [License](#license)

---

## About
**Enjin** is a portable, lightweight, and versatile Windows development environment for PHP developers. It allows you to run multiple **PHP versions** simultaneously and manage multiple projects with ease. With built-in support for **portable MySQL and MariaDB**, Enjin ensures a clean, isolated workflow without requiring system-wide installation of PHP or databases.

Perfect for testing legacy and modern PHP applications side-by-side on a USB drive or external disk.

---

## Demo
[![Enjin Demo](https://img.youtube.com/vi/iyH5ek-Asv4/0.jpg)](https://www.youtube.com/watch?v=iyH5ek-Asv4)
*Watch the full tutorial on [YouTube](https://www.youtube.com/watch?v=iyH5ek-Asv4).* 

---

## Features
| Feature | Description |
|---------|-------------|
| 🚀 Fully Portable | Run from USB stick or cloud folder. No installation required. |
| 🔢 Multi-PHP Support | Easily switch between PHP 7.4, 8.0, 8.1, etc., for different projects. |
| ⚙️ Interactive Runner | `run.bat` script guides you through selecting a folder and PHP version. |
| 💾 Portable Database Support | Pre-configured for portable MySQL/MariaDB without installing services. |
| 🛠️ Clean Structure | Manual project control. Create folders in `root` and run servers instantly. |
| 🖥️ Framework Support | Preconfigured to work with Laravel, CodeIgniter, and other PHP frameworks. |

---

## Folder Structure
```text
G:\enjin\
│
├─ php\
│  ├─ php81\
│  │  ├─ php.exe
│  │  └─ ext\
│  ├─ php82\
│  └─ ... (Add more versions here)
│
├─ root\            (Create your project folders here)
│  ├─ my_app\
│  └─ index.php
│
├─ database\        (Portable MySQL/MariaDB folders)
│  ├─ mysql57\
│  ├─ mysql80\
│  └─ ...
│
├─ run.bat        (Interactive Server Runner)
└─ config.ini     (Configuration file)
```

---

## Quick Start
### 1. Download & Extract
Download the latest release and extract it to your desired location (e.g., `G:\enjin\`).

### 2. Create Project Folder
Navigate to the `root` folder manually and create a new folder for your project (e.g., `my_project`). Add your PHP files (like `index.php`) into this folder.

### 3. Run the Script
Go back to the main directory (`G:\enjin\`) and double-click **`run.bat`**.

### 4. Interact
The script will guide you:
1. **Enter Project Folder Name:** Type the folder you created in `root`.
2. **Select PHP Version:** Choose from the list of detected versions.
3. **(Optional) Custom Domain/Port:** Set specific host/port if needed.

The server will start automatically!

---

## Configuration
You can edit `config.ini` to set global defaults. This file is read by `run.bat`.

```ini
SERVER_ROOT=G:\enjin\
SERVER_DOC_ROOT=G:\enjin\root\
DEFAULT_HOST=localhost
DEFAULT_PORT=8000
```

---

## Advanced Configuration
### Adding a New PHP Version
1. Download the **Thread Safe** Zip version for Windows from [php.net](https://windows.php.net/download/).
2. Extract it into the `php` folder (e.g., `G:\enjin\php\php83\`).
3. Copy `php.ini-development` to `php.ini` and configure extensions if needed.
4. Restart `run.bat` to see the new version in the list.

### Installing Portable MySQL
1. Download the **ZIP** (not MSI Installer) portable MySQL/MariaDB.
2. Extract to the `database` folder (e.g., `G:\enjin\database\mysql81\`).
3. Create a `data` folder inside the extracted directory.
4. Run PowerShell as Administrator and initialize the database:
```bash
mysqld --initialize-insecure --datadir="G:\enjin\database\mysql81\data"
```
5. Start the server manually using `mysqld.exe` inside the `bin` folder.

---

## Sponsorship & Donations
If Enjin helps you develop faster or manage your projects more effectively, please consider supporting its development.

[![Donate](https://img.shields.io/badge/Donate-PayPal-gold.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=tuhiny2k5@gmail.com&item_name=Enjin+Donation)
*Donate via PayPal: https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=tuhiny2k5@gmail.com&item_name=Enjin+Donation*

---

## Hire Me
I am the creator of Enjin and available for freelance projects.

**My Tech Stack:**
- **Backend:** PHP, MySQL, Laravel, CodeIgniter
- **Frontend:** Vue.js, React.js, AngularJS
- **Domains:** HRM Systems, CRM Solutions, E-commerce platforms

Feel free to contact me for custom web development or configuration services.

---

## Support & Contact
- 🐛 **Issues:** [Report a bug or request a feature on GitHub](https://github.com/archivetuhin/enjin-portable-php-mysql-project-maker/issues)
- 📧 **Email:** [tuhiny2k5@gmail.com](mailto:tuhiny2k5@gmail.com)
- 💬 **WhatsApp:** [+8801837742506](https://wa.me/8801837742506)

---

## License
This project is provided as-is for local development and learning purposes. It is open source under the **MIT License**. You are free to modify and redistribute it within your own projects.

**Created with ❤️ by [archivetuhin](https://github.com/archivetuhin)**
