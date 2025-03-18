# Introduction to Docker

### 1: What is Docker?

- Docker is a platform for developing, shipping, and running applications in containers.
- Uses containerization to package applications with dependencies.
- Ensures consistency across environments (dev, test, prod).

---

### 2: Why Use Docker?

- Works across different OS environments.
- Lightweight compared to Virtual Machines.
- Faster deployment and scaling.
- Simplifies dependency management.

---

### 3: Docker vs Virtual Machines

| Feature        | Docker Containers | Virtual Machines |
| -------------- | ----------------- | ---------------- |
| Startup Time   | Seconds           | Minutes          |
| OS             | Shares Host OS    | Requires Full OS |
| Resource Usage | Low               | High             |
| Portability    | High              | Limited          |

---

### 4: Key Docker Components

- **Docker Engine**: Runs and manages containers.
- **Docker Images**: Read-only templates to create containers.
- **Docker Containers**: Running instances of images.
- **Docker Hub**: Repository for storing and sharing images.

---

### 5: Basic Docker Commands

```sh
docker run hello-world  # Run a test container
docker ps  # List running containers
docker ps -a # List all containers
docker images  # List downloaded images
docker stop <container_id>  # Stop a running container
docker rm <container_id>  # Remove a container
```

---

### 6: Installing Docker

- **Windows**: Install Docker Desktop.
- **Mac**: Install Docker Desktop.
- **Linux**: Use package manager (`apt`, `yum`).
- Verify installation:

```sh
docker --version
```

---

### 7: Running Your First Container

```sh
docker run -d -p 80:80 nginx
```

- Open browser and visit `http://localhost`
- Shows Nginx welcome page.

---
### 8. Mount local folder in nginx Container
```sh
docker run -d --name mynginx -p 8080:80 -v /home/vignesh/nginx_data:/usr/share/nginx/html:ro nginx
```
### Summary

- Docker simplifies application deployment.
- Lightweight and portable compared to VMs.
- Basic commands to get started.

# Dockerfile Guide

## What is a Dockerfile?
A Dockerfile is a script that contains a set of instructions to automate the creation of a Docker image. It defines the base image, dependencies, configurations, and the command to run the containerized application.

## Basic Structure of a Dockerfile
```dockerfile
# Use a base image
FROM ubuntu:latest

# Set environment variables (optional)
ENV APP_NAME="MyApp"

# Install dependencies
RUN apt-get update && apt-get install -y curl python3 python3-pip

# Copy application files
COPY . /app

# Set working directory
WORKDIR /app

# Expose ports
#EXPOSE 8080

# Define startup command
CMD ["python3", "app.py"]
```

## Common Dockerfile Instructions
- **FROM**: Specifies the base image.
- **RUN**: Executes commands inside the container.
- **COPY**: Copies files from the host to the container.
- **WORKDIR**: Sets the working directory inside the container.
- **CMD**: Specifies the default command to run when the container starts.
- **ENTRYPOINT**: Similar to CMD but used for defining executable scripts.
- **EXPOSE**: Defines the port on which the container will listen.

## Building and Running a Docker Image
### 1. Create a Dockerfile
Ensure the `Dockerfile` is saved in your project directory.

### 2. Add an Application File (Example `app.py`)
```python
# app.py
print("Hello, Docker!")
```

### 3. Build the Image
Run the following command in the terminal inside the directory containing the `Dockerfile`:
```sh
docker build -t myapp .
```

### 4. Run a Container from the Image
```sh
docker run --name myapp_container myapp
```

### 5. Check Running Containers
```sh
docker ps
```

### 6. Access the Container
To open an interactive shell inside the running container:
```sh
docker exec -it myapp_container bash
```

### 7. View Logs
To check container output:
```sh
docker logs myapp_container
```

### 8. Stop and Remove the Container
```sh
docker stop myapp_container
docker rm myapp_container
```

### 9. Remove the Image (Optional)
```sh
docker rmi myapp
```

## Best Practices
- Use a minimal base image to reduce size.
- Combine `RUN` instructions to minimize layers.
- Use `.dockerignore` to exclude unnecessary files.
- Avoid running containers as root.
- Use multi-stage builds for efficient image size reduction.

## Conclusion
A well-structured Dockerfile helps in creating efficient and secure Docker images. Following best practices ensures better performance, security, and maintainability.

---
