# RBI Payment Platform — Kubernetes DevOps Assessment

## Overview

This project demonstrates the deployment and validation of a payment platform on Kubernetes using production-oriented DevOps practices.

The platform consists of two services:

* **Payment Gateway** — handles incoming payment requests and communicates with the payment processor.
* **Payment Processor** — processes payment-related operations and exposes a health endpoint.

The Kubernetes implementation includes application deployments, services, configuration management, secrets, network policies, service accounts, and PodDisruptionBudgets.

---

## Architecture

```text
                    Client
                      |
                      v
            +-------------------+
            |  Payment Gateway  |
            |    NodePort       |
            |    Port: 8080     |
            +---------+---------+
                      |
                      | HTTP
                      v
            +-------------------+
            | Payment Processor |
            |    ClusterIP      |
            |    Port: 8080     |
            +---------+---------+
                      |
                Health Check
                 /healthz
                      |
                      v
                  HTTP 200
```

---

## Technology Stack

* Kubernetes
* Docker
* Linux / Bash
* Git
* YAML
* Kubernetes Services
* Kubernetes ConfigMap
* Kubernetes Secrets
* Kubernetes NetworkPolicy
* Kubernetes ServiceAccount
* Kubernetes PodDisruptionBudget

---

## Project Structure

```text
rbi-payment-devops/
│
├── k8s/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.example.yaml
│   ├── serviceaccount.yaml
│   ├── network-policy.yaml
│   │
│   ├── gateway/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   │
│   ├── processor/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   │
│   └── pdb/
│       ├── gateway-pdb.yaml
│       └── processor-pdb.yaml
│
├── scripts/
│   ├── deploy.sh
│   └── test.sh
│
└── README.md
```

---

## Kubernetes Components

### Namespace

All application resources are deployed into:

```text
payment-platform
```

### Payment Gateway

The gateway is deployed with multiple replicas and exposed using a Kubernetes NodePort service.

```text
Service Port: 8080
NodePort: 30080
```

### Payment Processor

The processor runs as a Kubernetes Deployment and is exposed internally using a ClusterIP service.

```text
Service Port: 8080
```

The gateway communicates with the processor using:

```text
http://payment-processor:8080
```

### Configuration

Application configuration is managed using a Kubernetes ConfigMap.

### Secrets

Sensitive configuration is represented using a Kubernetes Secret.

The repository contains an example secret file rather than relying on hard-coded credentials.

### NetworkPolicy

A Kubernetes NetworkPolicy is configured for the payment processor to control network communication.

### PodDisruptionBudget

PodDisruptionBudgets are configured for both the gateway and processor to improve availability during voluntary disruptions.

---

## Deployment

The deployment can be performed using the provided script:

```bash
./scripts/deploy.sh
```

The deployment script:

1. Verifies Kubernetes connectivity.
2. Creates/applies the application namespace.
3. Applies the Kubernetes configuration.
4. Deploys the payment processor.
5. Deploys the payment gateway.
6. Validates the deployed resources.

---

## Validation

The project includes a validation script:

```bash
./scripts/test.sh
```

The validation checks:

* Kubernetes cluster connectivity
* Namespace status
* Deployment rollout status
* Pod status
* Kubernetes Services
* Payment processor endpoints
* Payment Secret
* NetworkPolicy
* PodDisruptionBudgets

A successful validation produces:

```text
Kubernetes validation completed successfully.
```

---

## Application Health Check

The payment gateway communicates with the payment processor through the Kubernetes service:

```text
http://payment-processor:8080/healthz
```

Successful application communication returns:

```text
HTTP/1.1 200 OK
```

This confirms that:

* Kubernetes service discovery is working.
* The processor service is reachable.
* Processor pods are accepting requests.
* Gateway-to-processor communication is functioning correctly.

---

## Validation Results

The deployed environment was successfully validated with:

```text
Namespace: payment-platform
Status: Active

Payment Gateway:
2/2 pods Running and Ready

Payment Processor:
2/2 pods Running and Ready

Payment Processor Endpoints:
2 available endpoints

Payment Secret:
Present

NetworkPolicy:
Present

PodDisruptionBudgets:
Gateway: Present
Processor: Present

Application Health:
HTTP 200 OK
```

---

## Git

The project is maintained using Git with the `main` branch.

Example commit:

```bash
git commit -m "Implement Kubernetes payment platform"
```

The repository is hosted on GitHub.

---

## Security Considerations

* Secrets are represented using Kubernetes Secret resources.
* Example configuration is separated from application deployment configuration.
* NetworkPolicy is used to restrict processor network access.
* ServiceAccount resources are defined for Kubernetes workloads.
* No real credentials should be committed to the repository.

---

## Future Improvements

The platform can be extended with:

* CI/CD pipeline using Jenkins
* Docker image build and scanning
* Container registry integration
* Helm-based deployment
* Ingress and TLS
* Prometheus and Grafana monitoring
* Centralized logging using ELK
* Argo CD for GitOps
* Terraform-based infrastructure provisioning
* Automated security scanning

---

## Author

**Ayushi Gadwal**

DevOps Engineer

