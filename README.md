# hello-app Helm Chart Template

This repository provides a minimal, production-ready Helm chart and CI pipeline for deploying simple HTTP echo apps (or similar) to Kubernetes, with automated Ingress and TLS secret handling.

## Features
- Minimal Helm chart for a containerized app
- Automated Ingress creation with TLS (manual wildcard secret copy)
- GitHub Actions workflow for building and pushing Docker images to GHCR
- Ready-to-use Dockerfile (http-echo example)
- **Argo CD** used for deployment and GitOps

---

## How to Use as a Template Repository

1. **Click "Use this template"** on GitHub to create a new repository for your app.
2. **Clone your new repository locally:**
   ```sh
   git clone https://github.com/<your-username>/<your-new-repo>.git
   cd <your-new-repo>
   ```

3. **Update the app name:**
   - Rename all instances of `hello-app` to your new app name:
     - In `charts/hello-app/` directory and subfiles (rename the directory and update references in YAML files)
     - In `values.yaml` (image repository, ingress hosts, etc.)
     - In `Chart.yaml` (name, description)
     - In GitHub Actions workflow (`.github/workflows/ci.yaml`), update the Docker image tag if needed

4. **Customize the Dockerfile:**
   - Replace the `hashicorp/http-echo` image and command with your own app's build instructions and entrypoint.

5. **Update Ingress and TLS settings:**
   - In `values.yaml`, set the correct domain, TLS secret, and namespace for your new app.

6. **Push your changes:**
   ```sh
   git add .
   git commit -m "Initial commit for <your-app-name>"
   git push origin main
   ```

7. **Build & Deploy:**
   - On push to `main`, the GitHub Actions workflow will build and push your Docker image to GHCR.
   - **Deployment is managed by Argo CD.**
   - Install the Helm chart to your cluster (if not using Argo CD directly):
     ```sh
     helm install <release-name> charts/<your-app-name> --namespace <namespace> --create-namespace
     ```

---

## Manual TLS Secret Copy (Required for Ingress TLS)
This chart does **not** automate copying the wildcard TLS secret. You must manually copy the TLS secret into each app's namespace before deploying with Argo CD or Helm.

**Command:**
```sh
kubectl get secret web-wildcard-tls -n test-tls -o yaml \
  | sed 's/namespace: test-tls/namespace: <your-app-namespace>/' \
  | kubectl apply -f -
```
Replace `<your-app-namespace>` with your app's namespace (e.g. `hello-app`).

- The Ingress template expects the secret to be named `web-wildcard-tls` in the app's namespace.
- If the secret is missing, Ingress TLS will not work.

---

## What to Change for a New App
- **App name:** everywhere you see `hello-app`
- **Docker image:** repository, tag, and Dockerfile contents
- **Ingress host/domain:** in `values.yaml`
- **TLS secret/namespace:** in `values.yaml` (for documentation, but secret copy is manual)
- **Chart metadata:** in `Chart.yaml`

---

## Example: Creating a New App
Suppose you want to create `my-cool-app`:
1. Use this template to create `my-cool-app` repo.
2. Rename `charts/hello-app` to `charts/my-cool-app` and update all references.
3. Update `values.yaml`:
   - `image.repository: ghcr.io/<your-gh-username>/my-cool-app`
   - `ingress.hosts.host: my-cool-app.example.com`
   - `ingress.tls[0].hosts: my-cool-app.example.com`
   - `ingress.tls[0].secretName: <your-tls-secret>`
   - `ingress.tlsSecretNamespace: <your-tls-namespace>`
4. Update `Chart.yaml` and `.github/workflows/ci.yaml` as needed.
5. **Manually copy the wildcard TLS secret** to the new namespace (see above).
6. Push and deploy! Argo CD will pick up the changes and deploy your app.

---

## License
MIT 