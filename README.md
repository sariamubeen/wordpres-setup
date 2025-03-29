# WordPress Auto Setup Script

This repository contains a Bash script that automates the setup of a full WordPress environment on an **Ubuntu** server. It installs the **latest PHP (8.3)**, Apache, MySQL, and all required PHP extensions, configures the database, downloads WordPress, and sets up everything for you.

---

## 🚀 Features
- Installs latest PHP (via `ondrej/php` PPA)
- Installs Apache, MySQL, and required PHP extensions
- Creates WordPress database and user
- Downloads and configures latest WordPress
- Sets proper file permissions
- Injects secure salts from WordPress API

---

## 📦 Requirements
- Ubuntu Server (22.04 or later recommended)
- sudo/root access
- Internet connection

---

## 🔧 How to Use

1. **Clone this repo**:
```bash
git clone https://github.com/sariamubeen/wordpress-setup.git
cd wordpress-setup
```

2. **Make the script executable**:
```bash
chmod +x wordpress-setup.sh
```

3. **Run the script**:
```bash
./wordpress-setup.sh
```

4. **Follow prompts** to enter:
   - MySQL root password
   - WordPress DB name, user, and password

---

## 📂 Result
Once the script completes, WordPress will be available at:
```
http://your-server-ip/
```

---

## 🔒 Security Notes
- Salts are pulled directly from [WordPress.org](https://api.wordpress.org/secret-key/1.1/salt/)
- Ensure proper firewall and HTTPS configuration for production environments

---

## 🧰 To Do (Optional Enhancements)
- [ ] Add Let's Encrypt SSL auto-setup
- [ ] Set up Apache virtual hosts
- [ ] Add support for Nginx instead of Apache

---

## 📄 License
MIT

---

Happy WordPress-ing! 🎉

---

> 💡 PRs and suggestions welcome!

