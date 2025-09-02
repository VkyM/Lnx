# Jenkins CI/CD Pipeline: A Complete Guide

This guide walks you through setting up a full CI/CD pipeline using Jenkins, Docker, GitHub, and Kubernetes. You'll learn how to automate image building, versioning, and deployment.

-----

## 1\. Create Jenkins with Docker Compose

To get started, we'll run Jenkins using Docker Compose. This is a simple and reproducible way to set up your Jenkins master.

### `docker-compose.yml`

Create a file named `docker-compose.yml` with the following content:

```yaml
version: "3.9"

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    ports:
      - "8080:8080"      # Jenkins web UI
      - "50000:50000"    # For Jenkins agents
    volumes:
      - ./jenkins_home:/var/jenkins_home
    restart: unless-stopped
```

To start Jenkins, run the following commands in your terminal:

```bash
mkdir jenkins_home
docker compose up -d
```

Jenkins will be accessible at `http://localhost:8080`.

-----

## 2\. Add Same Host as a Jenkins Agent

For our pipeline, we will use the same machine running Jenkins as an agent. This setup allows the Jenkins master to delegate tasks like building and pushing Docker images to a dedicated agent.

### Steps

1.  From the Jenkins dashboard, navigate to **Manage Jenkins** \> **Nodes**.
2.  Click **New Node**, give it a name like **`test1`**, select **Permanent Agent**, and click **Create**.
3.  On the next page, set the **Remote root directory** to `/home/jenkins/agent` and choose **Launch agent by connecting to the master** as the launch method.
4.  Follow the instructions provided by Jenkins to connect the agent to the master. This usually involves running a command in your terminal.

-----

## 3\. Add Policy for Jenkins User to Push Images

For Jenkins to push Docker images to Amazon ECR, it needs specific permissions. You must attach an IAM policy to the user or role that your Jenkins agent uses.

### IAM Policy

Create a new IAM policy with the following JSON:

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "ECRPushAccess",
			"Effect": "Allow",
			"Action": [
				"ecr:GetAuthorizationToken",
				"ecr:BatchCheckLayerAvailability",
				"ecr:PutImage",
				"ecr:InitiateLayerUpload",
				"ecr:UploadLayerPart",
				"ecr:CompleteLayerUpload",
				"ecr:DescribeRepositories"
			],
			"Resource": "*"
		}
	]
}
```

This policy grants permissions to authenticate with ECR and to build and push images to any repository.

-----

## 4\. Add Jenkins User in EKS to Update Images

To allow Jenkins to deploy to your Kubernetes cluster, you'll use **Role-Based Access Control (RBAC)**. This ensures that the Jenkins user has only the necessary permissions to update the image in a deployment.

### Kubernetes Manifests

Create two files, `jenkins-role.yaml` and `jenkins-rolebinding.yaml`, to define and bind the necessary permissions.

**`jenkins-role.yaml`**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: jenkins-image-updater
  namespace: stage
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "patch", "update"]
```

**`jenkins-rolebinding.yaml`**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jenkins-image-updater-binding
  namespace: stage
subjects:
- kind: User
  name: jenkins-user # The name of your Jenkins user/service account
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: jenkins-image-updater
  apiGroup: rbac.authorization.k8s.io
```

Apply these files to your cluster:

```bash
kubectl apply -f jenkins-role.yaml
kubectl apply -f jenkins-rolebinding.yaml
```

-----

## 5\. Add GitHub Workflows for Labels and Versioning

Automate your release process with two GitHub Actions workflows. The first enforces semantic versioning (semver) labels on pull requests, and the second automatically bumps the version and creates a Git tag after a merge.

### a. Create the `.github/workflows` folder

Create a folder named `.github/workflows` at the root of your repository.

### b. `require-semver-label.yml`

This workflow ensures that a pull request has exactly one semver label (`semver:major`, `semver:minor`, or `semver:patch`) before it can be merged.

**File:** `.github/workflows/require-semver-label.yml`

```yaml
name: Require PR Label
on:
  pull_request:
    types: [opened, edited, labeled, unlabeled, synchronize]
permissions:
  pull-requests: write
  contents: read

jobs:
  check-labels:
    runs-on: ubuntu-latest
    steps:
      - name: Require semver label
        uses: actions/github-script@v7
        with:
          script: |
            const issue_number = context.payload.pull_request.number;
            const labels = context.payload.pull_request.labels.map(l => l.name);
            const requiredLabels = ["semver:major", "semver:minor", "semver:patch"];

            const hasRequiredLabel = labels.filter(l => requiredLabels.includes(l));

            if (hasRequiredLabel.length !== 1) {
              const body = "Please add exactly one of these labels before merging: semver:major - breaking changes, semver:minor - new features (backward-compatible), semver:patch - bug fixes. Once you add a valid label, the check will pass.";

              await github.rest.issues.createComment({
                ...context.repo,
                issue_number,
                body
              });

              core.setFailed("PR must have exactly one semver label.");
            }
```

### c. `auto-version.yml`

This workflow runs on a merged pull request, determines the new version based on the semver label, and creates a new Git tag.

**File:** `.github/workflows/auto-version.yml`

```yaml
name: Auto Version Bump
on:
  pull_request:
    branches:
      - main
      - dev
    types: [closed]

permissions:
  contents: write

jobs:
  bump-version:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4
        with:
          fetch-depth: 0   # Needed to fetch tags

      - name: Get latest tag
        id: get_tag
        run: |
          git fetch --tags
          latest=$(git tag --sort=-v:refname | head -n 1)
          if [ -z "$latest" ]; then
            latest="0.0.0"
          fi
          echo "latest=$latest" >> $GITHUB_OUTPUT

      - name: Determine next version
        id: bump
        run: |
          IFS='.' read -r major minor patch <<< "${{ steps.get_tag.outputs.latest }}"
          label=$(echo "${{ github.event.pull_request.labels[0].name }}")

          if [ "$label" = "semver:major" ]; then
            major=$((major+1))
            minor=0
            patch=0
          elif [ "$label" = "semver:minor" ]; then
            minor=$((minor+1))
            patch=0
          elif [ "$label" = "semver:patch" ]; then
            patch=$((patch+1))
          else
            echo "Error: PR must have a semver label (semver:major, semver:minor, semver:patch)"
            exit 1
          fi

          new_version="$major.$minor.$patch"
          echo "new_version=$new_version" >> $GITHUB_OUTPUT
          echo "Next version will be $new_version"

      - name: Create Git tag
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git tag ${{ steps.bump.outputs.new_version }}
          git push origin ${{ steps.bump.outputs.new_version }}
```

-----

## 6\. Jenkins Pipeline

This pipeline automates the entire CI/CD process. It cleans the workspace, checks out the code, fetches the latest tag created by the GitHub workflow, builds a new Docker image with that tag, pushes it to ECR, and updates the deployment in Kubernetes.

**File:** `Jenkinsfile`

```groovy
pipeline {
    agent { label 'test1' }

    environment {
        REGISTRY = "xxxxxxxx.dkr.ecr.ap-south-1.amazonaws.com/dev/jenkins"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('Checkout Repo') {
            steps {
                git branch: 'dev', url: 'git@github.com:VkyM/jenkins_ums.git'
            }
        }
        
        stage('Copy env') {
            steps {
                withCredentials([file(credentialsId: 'Ums_Dev', variable: 'ENV_FILE')]) {
                    sh '''
                        cp "$ENV_FILE" .env.dev
                    '''
                }
            }
        }
        
        stage('Fetch Latest Tag') {
            steps {
                script {
                    sh "git fetch --tags"
                    env.IMAGE_TAG = sh(script: "git describe --tags `git rev-list --tags --max-count=1`", returnStdout: true).trim()
                    echo "Latest Tag: ${env.IMAGE_TAG}"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${REGISTRY}
                        docker build -t ${REGISTRY}:${IMAGE_TAG} .
                        docker push ${REGISTRY}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                        kubectl set image deployment/ums-app ums-app=${REGISTRY}:${IMAGE_TAG} -n stage --record
                    """
                }
            }
        }
    }
}
```
