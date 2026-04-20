# Manual Testing Plan for Notes Application

## 1️⃣ Environment Setup

- Ensure **Docker** is installed and running.
- Pull the latest image from Docker Hub:
    ```bash
    docker pull ayusht45cyber/notes-keeping:latest
    ```
- Run the container interactively:
    ```bash
    docker run -it --rm ayusht45cyber/notes-keeping
    ```
- Verify logs to ensure that services start without errors.

---

## 2️⃣ Build Stage Testing

| **Test Case**                         | **Steps**                                      | **Expected Outcome**                                           |
|---------------------------------------|------------------------------------------------|---------------------------------------------------------------|
| **Build Docker Image**                | Run `docker build -t "$IMAGE_NAME:$IMAGE_TAG" .` | Docker image builds successfully without errors.               |
| **Save Image**                        | Run `docker save -o image.tar "$IMAGE_NAME:$IMAGE_TAG"` | Image is saved as a tar file for the next stage.               |
| **Check Image Size**                  | Run `docker images | grep notes-keeping`         | The image size should be reasonable for the application.       |

---

## 3️⃣ Test Stage Testing

| **Test Case**                         | **Steps**                                      | **Expected Outcome**                                           |
|---------------------------------------|------------------------------------------------|---------------------------------------------------------------|
| **Load Docker Image**                 | Run `docker load -i image.tar`                  | Docker image loads successfully without errors.                |
| **Run the Container**                 | Run `docker run -d --name test-container "$IMAGE_NAME:$IMAGE_TAG"` | Container starts successfully in detached mode.                |
| **Check Nginx Process**               | Run `docker exec test-container pgrep -fl "nginx" || exit 1` | Nginx process is running inside the container.                 |
| **Check Nginx Port**                  | Run `docker exec test-container netstat -an | grep ':80 '` | Nginx is listening on port 80 (or specified port).             |
| **Test Health Check Endpoint**       | Run `docker exec test-container curl -s http://localhost/health || exit 1` | Application responds to `/health` endpoint.                    |
| **Test Default HTTP Route**          | Run `docker exec test-container curl -s http://localhost || exit 1` | Application responds to the default route or homepage.        |
| **Stop the Container**                | Run `docker stop test-container`                | Container stops successfully after testing.                    |

---

## 4️⃣ Deploy Stage Testing

| **Test Case**                         | **Steps**                                      | **Expected Outcome**                                           |
|---------------------------------------|------------------------------------------------|---------------------------------------------------------------|
| **Docker Hub Login**                  | Run `echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin` | Successful login to Docker Hub.                               |
| **Load Docker Image**                 | Run `docker load -i image.tar`                  | Docker image loads successfully before pushing.                |
| **Push Image to Docker Hub**          | Run `docker push "$IMAGE_NAME:$IMAGE_TAG"`       | Docker image is pushed to Docker Hub successfully.             |

---

## 5️⃣ Performance Testing

| **Test Case**                         | **Steps**                                      | **Expected Outcome**                                           |
|---------------------------------------|------------------------------------------------|---------------------------------------------------------------|
| **Container Startup Time**           | Measure startup time from `docker run` to readiness | Should be <5 seconds                                            |
| **Memory Usage**                     | Monitor `docker stats`                         | Memory usage stays within expected limits.                     |
| **CPU Usage**                        | Execute multiple CRUD operations on the app   | No excessive CPU spikes or crashes during operations.          |

---

## 6️⃣ Security Testing

| **Test Case**                         | **Steps**                                      | **Expected Outcome**                                           |
|---------------------------------------|------------------------------------------------|---------------------------------------------------------------|
| **Docker Security Scan**             | Run `docker scan ayusht45cyber/notes-keeping`  | No critical vulnerabilities found.                             |
| **Environment Variables Security**   | Check `.env` and logs for exposed credentials  | No credentials should be visible in logs or environment.       |
| **Container Isolation**              | Attempt to access the host filesystem from the container | Access to the host filesystem should be restricted.            |

---

## 7️⃣ Usability Testing

| **Test Case**                         | **Steps**                                      | **Expected Outcome**                                           |
|---------------------------------------|------------------------------------------------|---------------------------------------------------------------|
| **User-Friendly Responses**          | Run `index.html` in a browser and interact with the app | Responses are clear and easy to understand.                    |
| **Error Messages Clarity**           | Provide incorrect inputs (e.g., blank fields)   | Errors should be informative and not vague.                    |

---
