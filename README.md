*This project has been created as part of the 42 curriculum by mavissar.*

<img alt="pink kaomoji" src="https://img.shields.io/badge/%E3%81%A5%EF%BD%A1%E2%97%95%E2%80%BF%E2%80%BF%E2%97%95%EF%BD%A1)%E3%81%A5-ff69b4?style=flat" />

# Inception

## <img src="https://placehold.co/12x12/f1c40f/f1c40f.png" alt="yellow" /> Description
This project consists of setting up a small infrastructure composed of different services under specific rules. The whole project has to be done in a virtual machine.

This repository focuses on **Docker**, **Docker Compose**, containers, networking, volumes, and service separation. The goal is to deepen understanding of system administration by building a Docker infrastructure from scratch, using specific operating systems (Debian/Alpine) and configuring services manually without pre-made images.

## <img src="https://placehold.co/12x12/f1c40f/f1c40f.png" alt="yellow" /> Instructions

### Prerequisites
- Docker + Docker Compose installed.
- Run the project inside a Virtual Machine (as required by the subject).
- A local domain pointing to your local IP in `/etc/hosts`: `127.0.0.1 mavissar.42.fr`

### Execution
Use the **Makefile** at the repository root to manage the lifecycle of the application.

- **Build & start:** `make`
- **Start (background):** `make up`
- **Stop:** `make down`
- **Rebuild:** `make re`
- **Clean data & containers:** `make fclean`

Environment variables must be stored in a `.env` file in `srcs/`. **Note:** No passwords should be committed in the repository.

---

## <img src="https://placehold.co/12x12/f1c40f/f1c40f.png" alt="yellow" /> Project Description & Design Choices

The infrastructure follows a strict micro-services architecture:
- **NGINX:** The only entrypoint, listening on port 443 (TLSv1.2/1.3). It handles HTTPS traffic and forwards PHP requests to WordPress.
- **WordPress:** Runs solely with PHP-FPM (no internal Nginx). It processes dynamic content and communicates with MariaDB.
- **MariaDB:** Stored in a secured application network, accessible only by WordPress, not directly from the host.

**Design Choices:**
- **Debian Bookworm** was chosen as the base image for stability and ease of package management (`apt`).
- **Docker Network:** A user-defined bridge network isolates the containers from the external world, ensuring only necessary ports are exposed.
- **Volumes:** Named volumes are used for persistence to ensure database and website data survive container restarts.

### Comparisons

#### 1. Virtual Machines vs Docker
Virtual Machines (VMs) and Docker containers differ primarily in architecture: VMs virtualize hardware, running a full guest OS, whereas Docker containers virtualize the operating system, sharing the host kernel.
- **Docker:** Faster startup, lightweight, less resource-intensive. Ideal for microservices.
- **VMs:** slower, heavier, but offer total isolation (own kernel).

![vvvvm](https://github.com/user-attachments/assets/79d62829-17ca-47e0-acd8-fe41d44e9a5f)

#### 2. Secrets vs Environment Variables
- **Environment Variables:** Useful for non-sensitive configuration (e.g., domain name, debug mode). The values are visible in `docker inspect`.
- **Secrets:** Encrypted and managed specifically for sensitive data (API keys, passwords). They are mounted as files inside the container (`/run/secrets/`), preventing exposure in environment logs.

#### 3. Docker Network vs Host Network
- **Docker Network (Bridge):** Provides isolation. Containers get their own IP addresses and DNS resolution within the Docker daemon. Ports must be explicitly published to be accessible from the host.
- **Host Network:** The container shares the host's networking namespace. It uses the host's IP and ports directly. Forbidden in this subject because it breaks isolation.

#### 4. Docker Volumes vs Bind Mounts
- **Bind Mounts:** A specific file or directory on the host machine is mounted into the container. Dependent on the host's file system structure.
- **Docker Volumes:** Managed completely by Docker (stored in `/var/lib/docker/volumes/`). They are safer, portable, and easier to back up. In this project, named volumes are required to decouple storage from the host's specific path structure.

---

## <img src="https://placehold.co/12x12/f1c40f/f1c40f.png" alt="yellow" /> Resources

### References
- **Docker Docs:** [https://docs.docker.com/](https://docs.docker.com/)
- **Docker Compose Docs:** [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- **NGINX Documentation:** [https://nginx.org/en/docs/](https://nginx.org/en/docs/)
- **WordPress + PHP-FPM:** [https://www.php.net/manual/en/install.fpm.php](https://www.php.net/manual/en/install.fpm.php)
- **MariaDB Knowledge Base:** [https://mariadb.com/kb/en/documentation/](https://mariadb.com/kb/en/documentation/)

### AI Usage
AI assistants (such as GitHub Copilot and ChatGPT) were used to:
- Clarify concepts regarding Docker networking and TLS configuration.
- Debug configuration errors in `nginx.conf` and `docker-compose.yml`.
- Reorganize and format this README to ensure compliance with the 42 subject requirements.
- Verify shell script logic for the MariaDB setup.

---

## <img src="https://placehold.co/12x12/f1c40f/f1c40f.png" alt="yellow" /> Additional Concepts (Glossary)

### Docker Components
- **Dockerfile:** A text document that contains all the commands a user could call on the command line to assemble an image.
- **Image:** An executable package that includes everything needed to run an application—the code, a runtime, libraries, environment variables, and config files.
- **Entrypoint:** The instruction that allows you to configure a container that will run as an executable.
- **Daemon:** The background process (`dockerd`) that manages Docker objects.

### PID 1
In a Docker container, **PID 1** is the process that starts the container. If PID 1 dies, the container dies. It requires special handling for signals (like SIGTERM) because Linux kernels treat PID 1 differently than other processes.
