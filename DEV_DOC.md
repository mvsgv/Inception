# Developer Documentation - Inception

This document provides technical details for developers working on or maintaining the Inception infrastructure. It covers the environment setup, build process, service architecture, and data persistence strategies.

## 1. Prerequisites

Ensure the following tools are installed on your development machine:
- **Docker Engine** (and Docker CLI)
- **Docker Compose** (V2 recommended)
- **Make** (for build automation)
- **sudo** privileges (required for host file modification)

## 2. Environment Setup

### 2.1 Configuration
The project is configured via environment variables. A template is provided in `srcs/.env.exemple`.

To set up your local environment:
1. Copy the example file:
   ```bash
   cp srcs/.env.exemple srcs/.env
   ```
2. Fill in the required secrets in `srcs/.env` (Database passwords, Admin credentials, etc.).

### 2.2 Directory Structure
The project enforces a specific directory structure for data persistence on the host machine.
- **Database Data**: `/home/mavissar/data/database` (Mapped to MariaDB)
- **WordPress Files**: `/home/mavissar/data/wordpress_files` (Mapped to WordPress and NGINX)

> **Note**: These paths are defined in `srcs/docker-compose.yml` and the `Makefile`. If you are running this project as a different user, you must update the absolute paths in those files.

## 3. Build and Launch

The project uses a `Makefile` to automate Docker Compose commands and host system configuration.

### Common Commands

| Command | Description |
|---------|-------------|
| `make` / `make up` | Creates data directories, updates `/etc/hosts` for the custom domain, builds images, and starts containers. |
| `make down` | Stops and removes the containers. |
| `make clean` | Stops containers and removes associated Docker volumes (data remains on host). |
| `make fclean` | **Deep Clean**: Removes containers, images, volumes, creates a backup of data, and **deletes** `~/data` from the host. Also reverts `/etc/hosts`. |
| `make status` | Displays current status of containers and images. |
| `make backup` | Archives the content of `~/data` to `~/data.tar.gz`. |

## 4. Architecture and Services

The infrastructure consists of three main services orchestrating via Docker Compose.

### 4.1 NGINX (`nginx`)
- **Role**: Reverse Proxy & Web Server.
- **Ports**: Exposes port `443` (HTTPS).
- **Dependencies**: Depends on `wordpress`.
- **Configuration**:
    - SSL certificates are generated or provided via build arguments.
    - Serves static content from the shared `wordpress_files` volume.
    - Proxies dynamic requests to the `wordpress` container.
- **Network**: Connects to the `all` bridge network.

### 4.2 WordPress (`wordpress`)
- **Role**: Application Server (PHP-FPM).
- **Dependencies**: Depends on `mariadb`.
- **Configuration**:
    - Installs and configures WordPress + CLI.
    - Connects to the database using environment variables.
- **Volumes**: Mounts `wordpress_files` to `/var/www/inception/`.
- **Network**: Internal only; not exposed directly to the host.

### 4.3 MariaDB (`mariadb`)
- **Role**: Database Server.
- **Configuration**:
    - Initializes the database and users based on `.env` variables.
- **Volumes**: Mounts `database` to `/var/lib/mysql/`.
- **Network**: Internal only.

## 5. Data Persistence & Volumes

Data persistence is handled using Docker named volumes with "bind mount" driver options. This allows Docker to manage the volume lifecycle while keeping files accessible on the host file system.

### Volume Configuration
Defined in `srcs/docker-compose.yml`:

```yaml
volumes:
  database:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/mavissar/data/database

  wordpress_files:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/mavissar/data/wordpress_files
```

### Network
All services communicate over a custom bridge network named `all`.
- **DNS Resolution**: Services can reach each other by their container names (`mariadb`, `wordpress`, `nginx`).

## 6. Host Configuration
The `Makefile` automatically manages the local domain resolution.
- **On `make up`**: Adds `127.0.0.1 mavissar.42.fr` to `/etc/hosts`.
- **On `make fclean`**: Removes the entry from `/etc/hosts`.

This ensures the site is accessible via `https://mavissar.42.fr` locally.
