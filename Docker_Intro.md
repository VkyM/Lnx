# Introduction to Docker

**Introduction to Docker**

- **Vignesh M**
- **9-mar-2025**

---

## Slide 1: What is Docker?

- Docker is a platform for developing, shipping, and running applications in containers.
- Uses containerization to package applications with dependencies.
- Ensures consistency across environments (dev, test, prod).

---

## Slide 2: Why Use Docker?

- Works across different OS environments.
- Lightweight compared to Virtual Machines.
- Faster deployment and scaling.
- Simplifies dependency management.

---

## Slide 3: Docker vs Virtual Machines

| Feature        | Docker Containers | Virtual Machines |
| -------------- | ----------------- | ---------------- |
| Startup Time   | Seconds           | Minutes          |
| OS             | Shares Host OS    | Requires Full OS |
| Resource Usage | Low               | High             |
| Portability    | High              | Limited          |

---

## Slide 4: Key Docker Components

- **Docker Engine**: Runs and manages containers.
- **Docker Images**: Read-only templates to create containers.
- **Docker Containers**: Running instances of images.
- **Docker Hub**: Repository for storing and sharing images.

---

## Slide 5: Basic Docker Commands

```sh
docker run hello-world  # Run a test container
docker ps  # List running containers
docker images  # List downloaded images
docker stop <container_id>  # Stop a running container
docker rm <container_id>  # Remove a container
```

---

## Slide 6: Installing Docker

- **Windows**: Install Docker Desktop.
- **Mac**: Install Docker Desktop.
- **Linux**: Use package manager (`apt`, `yum`).
- Verify installation:

```sh
docker --version
```

---

## Slide 7: Running Your First Container

```sh
docker run -d -p 80:80 nginx
```

- Open browser and visit `http://localhost`
- Shows Nginx welcome page.

---

## Slide 8: Summary

- Docker simplifies application deployment.
- Lightweight and portable compared to VMs.
- Basic commands to get started.
- Next: Writing a Dockerfile.

---

## Slide 9: Q&A

- Ask any questions!
