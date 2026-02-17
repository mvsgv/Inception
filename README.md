*This project has been created as part of the 42 curriculum by mavissar.*

# Inception

## Description
This project consists of setting up a small infrastructure composed of different services under specific rules.  
The whole project has to be done in a virtual machine.

This repository focuses on Docker, Docker Compose, containers, networking, volumes, and service separation (NGINX, WordPress + PHP-FPM, MariaDB).


## Table of contents
- [Description](#description)
- [Project description (Docker & sources)](#project-description-docker--sources)
  - [Infrastructure overview](#infrastructure-overview)
  - [Main design choices](#main-design-choices)
  - [Sources included in this project](#sources-included-in-this-project)
- [Instructions](#instructions)
  - [Prerequisites](#prerequisites)
  - [Run](#run)
- [Required comparisons](#required-comparisons)
  - [Virtual Machines vs Docker](#virtual-machines-vs-docker)
  - [Secrets vs Environment Variables](#secrets-vs-environment-variables)
  - [Docker Network vs Host Network](#docker-network-vs-host-network)
  - [Docker Volumes vs Bind Mounts](#docker-volumes-vs-bind-mounts)
- [Concepts & notes (glossary)](#concepts--notes-glossary)
  - [Docker](#docker)
    - [What is a docker?](#what-is-a-docker)
    - [What is a Docker Image?](#what-is-a-docker-image)
    - [What is a Dockerfile?](#what-is-a-dockerfile)
    - [What is Entrypoint ?](#what-is-entrypoint-)
    - [What is a Docker Network?](#what-is-a-docker-network)
    - [What is a Docker Compose?](#what-is-a-docker-compose)
    - [What is the difference between Docker and host?](#what-is-the-difference-between-docker-and-host)
    - [What is daemon ?](#what-is-daemon-)
  - [Process model: PID 1](#process-model-pid-1)
    - [What is PID 1?](#what-is-pid-1)
  - [WordPress tooling](#wordpress-tooling)
    - [What is WP-CLI?](#what-is-wp-cli)
    - [what is .wordprezss php-fpm ?](#what-is-wordprezss-php-fpm-)
  - [FTP](#ftp)
    - [What is FTP? And How Does it Work?](#what-is-ftp-and-how-does-it-work)
  - [NGINX](#nginx)
    - [What is nginx](#what-is-nginx)
    - [What is a server?](#what-is-a-server)
  - [MariaDB and Alpine](#mariadb-and-alpine)
  - [.CONF ?](#conf-)
  - [what is docker hub ?](#what-is-docker-hub-)
- [Resources](#resources)
  - [References](#references)
  - [AI usage](#ai-usage)

---

## Instructions

### Prerequisites
- Docker + Docker Compose installed
- Run the project inside a Virtual Machine (as required by the subject)
- A local domain pointing to your local IP: `mavissar.42.fr` 

### Run
Use the Makefile at the repository root.

Examples (adjust to your Makefile targets if different):
- Build & start: `make`
- Start: `make up`
- Stop: `make down`
- Rebuild: `make re`
- Clean: `make clean`

Environment variables must be stored in a `.env` file. No passwords should be committed in the repository (prefer Docker secrets for sensitive values).

---

## Project description (Docker & sources)
The infrastructure is composed of:
- NGINX (TLSv1.2 or TLSv1.3 only) as the single entrypoint on port 443
- WordPress + PHP-FPM only (no nginx inside)
- MariaDB only (no nginx inside)
- Named volumes for database + website files (no bind mounts for these)
- A dedicated Docker network for container-to-container communication
- Restart policies to recover from crashes

---

## Required comparisons

### Virtual Machines vs Docker

What is a virtual machine ?  
A Virtual Machine (VM) is a compute resource that uses software instead of a physical computer to run programs and deploy apps. One or more virtual “guest” machines run on a physical “host” machine. Each virtual machine runs its own operating system and functions separately from the other VMs, even when they are all running on the same host. This means that, for example, a virtual MacOS virtual machine can run on a physical PC.


---


**CONTAINER**

What is a Container?  
A Container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another.

What is The Difference Between Container and VM?  
Containers and Virtual machines have similar resource isolation and allocation benefits but function differently because containers virtualize the operating system instead of the hardware. Containers are more portable and efficient.

Containers are an abstraction at the app layer that packages code and dependencies together. Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space. Containers take up less space than VMs (talks about tens of MBs in size), can handle more applications, and require fewer VMs and Operating Systems.

### Secrets vs Environment Variables
Environment variables are useful for configuration, but sensitive data (passwords, API keys) should not be committed in Git.  
Docker secrets are recommended for confidential information because they are handled separately and can reduce the risk of leaking credentials.

### Docker Network vs Host Network
Using a Docker network provides container isolation and controlled communication.  
Host networking is forbidden by the subject and also reduces isolation (containers share the host network stack).

### Docker Volumes vs Bind Mounts
When you use a bind mount, a file or directory on the host machine is mounted from the host into a container. By contrast, when you use a volume, a new directory is created within Docker's storage directory on the host machine, and Docker manages that directory's contents.

Volumes are persistent data stores for containers, created and managed by Docker. You can create a volume explicitly using the docker volume create command, or Docker can create a volume during container or service creation. When you create a volume, it's stored within a directory on the Docker host.


### Difference between vm and docker 

A VM lets you run a virtual machine on any hardware. Docker lets you run an application on any operating system. 
It uses isolated user-space instances known as containers. 
Docker containers have their own file system, dependency structure, processes, and network capabilities.

![vvvvm](https://github.com/user-attachments/assets/79d62829-17ca-47e0-acd8-fe41d44e9a5f)

---


## DOCKER

### What is a docker?
Docker is an operating system for containers. Similar to how a virtual machine virtualizes (removes the need to directly manage) server hardware, containers virtualize the operating system of a server. Docker is installed on each server and provides simple commands you can use to build, start, or stop containers.  
Docker is a tool designed to allow you to build, deploy and run applications in an isolated and consistent manner across different machines and operating systems. This process is done using CONTAINERS. which are lightweight virtualized environments that package all the dependencies and code an application needs to run into a single text file, which can run the same way on any machine.

While Docker is primarily used to package and run applications in containers, it is not limited to that use case. Docker can also be used to create and run other types of containers, such as ones for testing, development, or experimentation.

### What is a Docker Image?
Docker Image is a lightweight executable package that includes everything the application needs to run, including the code, runtime environment, system tools, libraries, and dependencies.

Although it cannot guarantee error-free performance, as the behavior of an application ultimately depends on many factors beyond the image itself, using Docker can reduce the likelihood of unexpected errors.

Docker Image is built from a DOCKERFILE, which is a simple text file that contains a set of instructions for building the image, with each instruction creating a new layer in the image.

### What is a Dockerfile?
Dockerfile is that SIMPLE TEXT FILE, which contains a set of instructions for building a Docker Image. It specifies the base image to use and then includes a series of commands that automate the process for configuring and building the image, such as installing packages, copying files, and setting environment variables. Each command in the Dockerfile creates a new layer in the image.

```yaml
  FROM  - defines a base for your image. exemple : FROM debian  
  RUN - executes any commands in a new layer on top of the current image and commits the result. RUN also has a shell form for running commands.  
  WORKDIR - sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow it in the Dockerfile. (You go directly in the directory you choose)  
  COPY - copies new files or directories from and adds them to the filesystem of the container at the path .  
  CMD - lets you define the default program that is run once you start the container based on this image. Each Dockerfile only has one CMD, and only the last CMD instance is respected       when multiple ones exist.
```

### What is Entrypoint ?
The ENTRYPOINT Dockerfile instruction sets the process executed when your container starts. It allows you to define the default behavior of a container by setting a specific application or script to be executed.

### What is a docker network?
A Docker network is a virtual networking system that enables Docker containers to communicate with each other, the host machine, and external networks. Using drivers, it creates isolated, secure, and configurable communication paths, allowing applications in containers to connect while maintaining isolation from other network traffic.  
Purpose: Enables container-to-container communication, connects containers to the host machine, and manages external connectivity.

### What is a Docker Compose?
Docker Compose is a powerful tool that simplifies the deployment and management of multi-container Docker applications. It provides several benefits, including simplifying the process of defining related services, volumes for data persistence, and networks for connecting containers. With Docker Compose, you can easily configure each service’s settings, including the image to use, the ports to expose, and the environment variables to set…

Overall, Docker Compose streamlines the development process, making it easier for you to build and deliver your applications with greater efficiency and ease.

A Docker Compose has 3 important parts, which are:

  - Services: A service is a unit of work in Docker Compose, it has a name, and it defines a container images, a set of environment variables,
    and a set of ports that are exposed to the host machine. When you run docker-compose up, Docker will create a new container for each service in your Compose file.  
  - Networks: A network is a way for containers to communicate with each other. When you create a network in your Compose file, Docker will create a new network that all the other       containers in your Compose file will be connected to. This allows containers to communicate with each other without even knowing the IP of each other, just by the name.  
  - Volumes: A volume is a way to store data that is shared between containers. When you create a volume in your Compose file, Docker will create a new volume (a folder in another        way) that all the containers have access to. This allows you to share data between the containers without having to copy-paste each and every time you want that data.

Example snippet:
```yaml
version: '3'

# All the services that you will work with should be declared under
# the SERVICES section!
services:

  # Name of the first service (for example: nginx)
  nginx:
  
    # The hostname of the service (will be the same as the service name!)
    hostname: nginx
    
    # Where the service exist (path) so you can build it
    build:
      context: ./requirements/nginx
      dockerfile: Dockerfile
      
    # Restart to always keep the service restarting in case of
    # any unexpected errors causing it to go down
    restart: always
    
    # This line explains itself!!!
    depends_on:
      - wordpress
      
    # The ports that will be exposed and you will work with
    ports:
      - 443:443
      
    # The volumes that will be mounted when the container gets built
    volumes:
      - wordpress:/var/www/html
      
    # The networks that the container will connect and communicate
    # with the other containers
    networks:
      - web
```

### What is the difference between Docker and host?
Docker host is the server (machine) on which Docker daemon runs. Docker containers are running instances of Docker images. Docker uses a client-server architecture. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker container

### What is daemon ?
Daemon is a computer program that runs as a background process rather than under the direct control of an interactive user. Common on Unix-like systems, daemons handle ongoing, repetitive tasks such as network services (httpd), printing, or system logging.


---


### What is PID 1?
In a Docker container, the PID 1 process is a special process that plays an important role in the container’s lifecycle. This process is the identifier of the init process, which is the first process that is started when the system boots up, and it is responsible for starting and stoping all of the other processes on the system. And in Docker as well, the init process is responsible for starting and stoping the application that is running in the container.
PID 1 in a Docker container behaves differently from the init process in a normal Unix-based system. (they are NOT the same!)

### Is the Daemon Process PID 1? And How Does They Differ From Each Other?
The daemon process is NOT the PID 1, the daemon process is a background process that runs continuosuly on a system and performs a specific task. In contrast, PID 1 is the first process that the kernel starts in a Unix-based system and plays a special role in the system.


---

## WordPress tooling

### What is WP-CLI?
WP-CLI is the command line interface for WordPress. It is a tool that allows you to interact with your WordPress site from the command line, it is used for a lot of purposes, such as automating tasks, debugging problems, installing/removing plugins along side with themes, managing users and roles, exporting/importing data, run databses queries, and so much more…

### what is .wordprezss php-fpm ?
PHP-FPM is a processor for PHP, one of the most common scripting languages, that enables WordPress sites to handle a greater volume of web traffic without relying on as many server resources as when using alternative PHP processors.

---

### What is FTP? And How Does it Work?
FTP or File Transfer Protocol is a protocol that’s used for transferring files between a client and a server over TCP/IP network, such as the internet. It provides a robust mechanism for users to upload, download, and manage files on remote servers.

FTP works by opening two connections that link the 2 hosts (client and server) trying to communicate between each other, one connection is designed for the commands and replies that gets sent between the two clients, and the other connection is handles the transfer of the data.

---

## NGINX

### What is nginx
is a high-performance, open-source web server, reverse proxy, load balancer, and HTTP cache. Known for its efficiency in handling thousands of concurrent connections with low memory usage, it is commonly used to serve static content, speed up dynamic websites, and distribute traffic across servers.

Nginx TLSv1.2 and TLSv1.3 are protocols securing HTTPS traffic by negotiating encryption between a client and server. TLSv1.3 is faster, using one-round-trip handshakes and modern, secure ciphers. TLSv1.2 is the widely supported, legacy standard. Enabling both (ssl_protocols TLSv1.2 TLSv1.3;) ensures maximum compatibility with modern security.

### What is a server?
A server is a powerful computer or software system on a network that manages, stores, and sends data, files, or applications to other devices, known as clients. Using a client-server model, it fulfills requests—such as loading a website or retrieving email—from multiple users simultaneously, acting as the backbone of digital networking.

---

## MariaDB and Alpine
MariaDB is an open-source relational database management system, while Alpine Linux is a lightweight, security-focused Linux distribution. MariaDB on Alpine (often used together in Docker) provides a, fast, and minimal-footprint database container, using musl libc and busybox instead of standard GNU/Linux tools.

Key Differences and Interactions:
- Definition: MariaDB is the software (database engine), while Alpine is the underlying operating system.
- Size: Alpine-based MariaDB containers are significantly smaller than the official MariaDB images based on Red Hat (UBI9) or Debian.
- Library: Alpine uses musl libc, which can sometimes lead to different behavior compared to glibc used in other distributions.
- Package Management: Alpine uses apk to install packages (apk add mariadb), whereas others use apt or dnf.
- Usage: You typically run a MariaDB container on an Alpine Linux base image to create a "tiny" database server.
- Performance & Security: Alpine is designed for security and speed, making it an excellent choice for containerized MariaDB.

---


### .CONF ?
Docker Configs are a resource in Docker for storing non-sensitive information such as configuration files, separate from a service's image or running containers within Docker Swarm environments.

### what is docker hub ?
Docker Hub is the world’s largest, cloud-based container registry service provided by Docker for storing, sharing, and managing Docker container images. It serves as a central repository, allowing users to pull pre-built, trusted images (including official images) and push custom images to facilitate containerized application development. Key features include image repositories, automated builds, and integration with CI/CD tools.

---

## Resources

### References
- Docker Docs: https://docs.docker.com/
- Docker Compose Docs: https://docs.docker.com/compose/
- Dockerfile reference: https://docs.docker.com/reference/dockerfile/
- NGINX documentation: https://nginx.org/en/docs/
- TLS (overview): https://datatracker.ietf.org/doc/html/rfc8446 (TLS 1.3), https://datatracker.ietf.org/doc/html/rfc5246 (TLS 1.2)
- WordPress + PHP-FPM: https://www.php.net/manual/en/install.fpm.php , https://wordpress.org/documentation/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/

### AI usage
AI was used to:
- Reorganize this README for clarity and compliance with the subject requirements.
- Suggest documentation structure and check for missing mandatory sections.

