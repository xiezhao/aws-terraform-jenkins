# Demo service

Small dependency-free Node.js service for the EKS Blue/Green deployment demo.
The `0.0.1` and `0.0.2` images show their version on the home page.

```sh
npm test
APP_VERSION=0.0.1 GIT_SHA=abc123 DEPLOY_COLOR=blue npm start
```

Run `0.0.2` locally with `APP_VERSION=0.0.2 GIT_SHA=def456 DEPLOY_COLOR=green PORT=3001 npm start`.
Open `http://localhost:3000` and `http://localhost:3001` to compare them.
For two container images, build the same Dockerfile twice with
`--build-arg APP_VERSION=0.0.1` and `--build-arg APP_VERSION=0.0.2`.
Push both images to ECR and pass `IMAGE_VERSION` (`0.0.1` or `0.0.2`) to the
Jenkins Deploy Pipeline. The ECR repository has immutable tags.

The service listens on port `3000` by default. Set `PORT` to change it.

| Path | Purpose |
| --- | --- |
| `/` | Plain-text version (`0.0.1` or `0.0.2`) |
| `/healthz` | Liveness probe |
| `/readyz` | Readiness probe |
| `/version` | Version, commit, and deployment color |
| `/api/greeting` | Sample business check; emits a structured log |

Build the image with `APP_VERSION` and `GIT_SHA` as build arguments. Set
`DEPLOY_COLOR` on each Kubernetes Deployment. Responses include
`Cache-Control: no-store` so release checks do not read a cached version.
