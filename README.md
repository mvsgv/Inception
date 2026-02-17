*This project has been created as part of the 42 curriculum by mavissar.*

# Inception

## Description

Inception is a system administration project that consists of setting up a small infrastructure composed of different services under specific rules. The entire project is implemented inside a **virtual machine** using **Docker Compose**. Each service runs in its own container, and the infrastructure is designed to follow best practices for containerization, security, and performance.

### Project Goals
- Set up a **NGINX** container as the only entry point to the infrastructure, serving traffic over **HTTPS** using **TLSv1.2** or **TLSv1.3**.
- Deploy a **WordPress** container with **php-fpm**, connected to a **MariaDB** database container.
- Use **Docker named volumes** to store persistent data:
  - One volume for the WordPress database.
  - One volume for the WordPress website files.
- Ensure all containers are connected via a **Docker network**.
- Configure the domain `<login>.42.fr` to point to the local IP address of the infrastructure.

### Key Constraints
- Containers must be built from **Alpine** or **Debian** base images (no pre-built images allowed, except for these).
- No passwords or sensitive data should be hardcoded in the repository. Use **environment variables** and **Docker secrets** for configuration.
- Containers must restart automatically in case of failure.
- No infinite loops (e.g., `tail -f`, `sleep infinity`, etc.) or `network: host` configuration is allowed.

---

## Project Overview

### Virtual Machines vs Docker
- **Virtual Machines**: Virtualize hardware and run a full guest OS. They are heavier but provide strong isolation. Each VM operates independently, even on the same host.
- **Docker Containers**: Virtualize the operating system, making them lightweight and faster to start. Containers share the host kernel and are ideal for service-oriented architectures.

This project uses a virtual machine as the required environment, with Docker containers to isolate and manage services.

### Secrets vs Environment Variables
- **Environment Variables**: Convenient for non-sensitive configuration but can be exposed through logs or `docker inspect`.
- **Docker Secrets**: Designed for sensitive data (e.g., passwords, API keys) and provide better security by keeping sensitive information out of the container environment.

This project uses a `.env` file for non-sensitive configuration and recommends **Docker secrets** for sensitive data.

### Docker Network vs Host Network
- **Docker Network**: Isolates containers and allows them to communicate securely using service names.
- **Host Network**: Removes isolation and is not allowed in this project.

This project uses a dedicated Docker network to connect the containers (nginx, WordPress, MariaDB).

### Docker Volumes vs Bind Mounts
- **Named Volumes**: Managed by Docker, portable, and secure. Ideal for persistent data.
- **Bind Mounts**: Directly map host paths to containers but are not allowed in this project.

This project uses **named volumes** to store persistent data under `/home/mavissar/data` on the host machine.

---

## Services

### NGINX
- **Purpose**: Acts as the only entry point to the infrastructure, handling HTTPS traffic on port **443**.
- **TLS Configuration**: Supports **TLSv1.2** and **TLSv1.3** for secure communication.
- **Dockerfile**: Configures NGINX with the required SSL certificates and settings.

### WordPress + php-fpm
- **Purpose**: Hosts the WordPress website.
- **php-fpm**: Used to handle PHP requests efficiently, allowing the site to handle high traffic with minimal resource usage.
- **Persistent Storage**:
  - WordPress files are stored in a named volume under `/home/mavissar/data/wordpress`.
  - Database data is stored in a named volume under `/home/mavissar/data/mariadb`.

### MariaDB
- **Purpose**: Provides the database for the WordPress site.
- **Base Image**: Built on Alpine Linux for a lightweight and secure container.
- **Persistent Storage**: Stores the database in a named volume under `/home/mavissar/data/mariadb`.

---

## Instructions

### Prerequisites
- A virtual machine with **Docker** and **Docker Compose** installed.
- A domain name (`mavissar.42.fr`) configured to point to the local IP address of the VM.

### Setup
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd Inception
   ```
2. Create the required directories on the host machine:
   ```bash
   mkdir -p /home/mavissar/data/wordpress
   mkdir -p /home/mavissar/data/mariadb
   ```
3. Create a `.env` file at the root of the project to store environment variables (e.g., database credentials, domain name, etc.).

### Build and Run
Use the provided `Makefile` to manage the project:
- **Build and start the containers**:
  ```bash
  make
  ```
- **Stop the containers**:
  ```bash
  make down
  ```
- **Clean up containers, images, and volumes**:
  ```bash
  make clean
  ```

Once the containers are running, access the WordPress site at:  
[https://mavissar.42.fr](https://mavissar.42.fr)

---

## Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)

### How AI Was Used
AI was used to:
- Organize and structure the README file according to the project requirements.
- Summarize and clarify technical concepts (e.g., Docker, Docker Compose, NGINX, MariaDB, etc.).
- Provide guidance on best practices for Dockerfiles, environment variables, and secrets.

All AI-generated content was reviewed and adapted to meet the project requirements and ensure accuracy.

---

## Additional Notes
- Ensure that your `.env` file does not contain any sensitive information that could be exposed in the repository.
- Follow best practices for Dockerfile creation, such as avoiding infinite loops, using `CMD` or `ENTRYPOINT` correctly, and ensuring proper process management with PID 1.
