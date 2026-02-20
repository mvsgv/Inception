# Inception - User Documentation

Welcome to the Inception project! This guide will help you understand, start, and manage your local Docker-based web infrastructure.

## 1. What is this project?
The Inception stack provides a complete, containerized web hosting environment running on your local machine. It includes:
*   **NGINX**: A secure web server handling incoming connections.
*   **WordPress**: The popular content management system for building your website.
*   **MariaDB**: A robust database to store your website's content and settings.

All these services run inside isolated containers to keep your system clean and organized.

## 2. Starting and Stopping the Project
You can control the entire infrastructure using simple commands from your terminal.

### Start the Services
To build and start the project, open your terminal in the project root and run:
```bash
make
```
*   This command will download necessary components, build the containers, and launch the website.
*   It might ask for your password to configure the local domain name (`mavissar.42.fr`).

### Stop the Services
To stop the website and free up resources:
```bash
make down
```

### Clean Up
If you want to remove the containers and reset the environment (but keep your data):
```bash
make clean
```
**Warning**: To completely remove everything, including your website data and database, use `make fclean`.

## 3. Accessing the Website
Once the project is running (you'll see a "UP" message or logs in the terminal), you can access the services:

*   **Website URL**: [https://mavissar.42.fr](https://mavissar.42.fr)
    *   *Note: Your browser might warn you about an "Unsafe" connection because we use a self-signed certificate. You can safely proceed/ignore this warning for this local project.*

*   **WordPress Admin Panel**: [https://mavissar.42.fr/wp-admin](https://mavissar.42.fr/wp-admin)
    *   Use this to log in as an administrator and edit your site.

## 4. Default Credentials
The project is configured with default credentials for testing. You can find or change these in the `.env` file located in the `srcs/` folder.

**Default Administrator (WordPress):**
*   **Username**: *(See `WP_ADMIN_USER` in `srcs/.env`)*
*   **Password**: *(See `WP_ADMIN_PASSWORD` in `srcs/.env`)*
*   **Email**: *(See `WP_ADMIN_EMAIL` in `srcs/.env`)*

**Default Editor User (WordPress):**
*   **Username**: *(See `WP_USER` in `srcs/.env`)*
*   **Password**: *(See `WP_PASSWORD` in `srcs/.env`)*

**Database Credentials:**
*   Database credentials (root user, database name) are also stored in `srcs/.env`.

> **Security Tip**: Never use these default passwords in a production environment.

## 5. Checking Service Status
To check if everything is running correctly, you can use the status command:
```bash
make status
```
This will list all running containers (`nginx`, `wordpress`, `mariadb`) and their current state. All of them should be listed as "Up".

If a service is not running, you can look at the logs (requires Docker knowledge) or try restarting the project with `make down` followed by `make`.
