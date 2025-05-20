# WordPress GCP Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-v1.0.0+-623CE4.svg)](https://www.terraform.io)
[![GCP](https://img.shields.io/badge/GCP-WordPress-4285F4.svg)](https://cloud.google.com/)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

This repository contains Terraform code to deploy a highly available, production-ready WordPress infrastructure on Google Cloud Platform (GCP). The infrastructure follows cloud best practices for scalability, security, and maintainability.

## Architecture Overview

The architecture uses Google Kubernetes Engine (GKE) as the primary compute platform for WordPress, along with Cloud SQL for MySQL database, Cloud DNS for domain management, global load balancing, and private connectivity between services.

![wordpress-gcp-architecture](https://github.com/user-attachments/assets/f11570dd-22ee-406f-b906-5942152a24cc)



### Key Components

- **Google Kubernetes Engine (GKE)** - Managed Kubernetes cluster for WordPress containers
- **Cloud SQL for MySQL** - Managed MySQL database with regional availability
- **Cloud Load Balancing** - Global load balancer with SSL termination
- **Cloud DNS** - Managed DNS zones for domain name configuration
- **VPC Network** - Custom VPC with private connectivity between services
- **Secret Manager** - Secure storage of database credentials
- **Cloud NAT** - Outbound internet access for private GKE nodes

## Infrastructure Features

- **High Availability**
  - Regional GKE cluster with node auto-scaling (1-3 nodes per zone)
  - Regional Cloud SQL instance with automatic failover
  - WordPress deployed with multiple replicas

- **Security**
  - Private GKE cluster (nodes not accessible from internet)
  - Private Cloud SQL instance (no public IP)
  - Secrets management for database credentials
  - SSL/TLS encryption for website traffic
  - Least privilege IAM roles
  - VPC firewall rules for network segmentation

- **Scalability**
  - Auto-scaling GKE node pool
  - WordPress deployment with horizontal scaling
  - Global load balancing for traffic distribution

- **Maintainability**
  - Modular Terraform code organization
  - Kubernetes manifest files for WordPress
  - Infrastructure as Code (IaC) approach
  - Setup scripts for easy deployment

## Repository Structure

```
wordpress-gcp-infra/
├── kubernetes/                # Kubernetes manifest files
│   ├── wordpress-certificate.yaml
│   ├── wordpress-db-secret.yaml
│   ├── wordpress-deployment.yaml
│   ├── wordpress-ingress.yaml
│   ├── wordpress-pvc.yaml
│   └── wordpress-service.yaml
├── modules/                   # Terraform modules
│   ├── database/              # Cloud SQL setup
│   ├── dns/                   # Cloud DNS configuration
│   ├── gke/                   # GKE cluster resources
│   ├── load_balancer/         # Global load balancer
│   └── networking/            # VPC and related resources
├── scripts/                   # Helper scripts
│   └── setup-wordpress.sh     # WordPress deployment script
├── .gitignore
├── LICENSE
├── README.md
├── main.tf                    # Main Terraform configuration
├── outputs.tf                 # Output definitions
├── variables.tf               # Input variable definitions
└── versions.tf                # Provider versions and setup
```

## Prerequisites

- Terraform v1.0.0+
- Google Cloud SDK (gcloud)
- kubectl
- A registered domain name
- GCP project with billing enabled

## Required GCP APIs

The following GCP APIs need to be enabled in your project:

- Compute Engine API
- Kubernetes Engine API
- Cloud SQL Admin API
- Secret Manager API
- Cloud DNS API
- Container Registry API

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/wordpress-gcp-infra.git
cd wordpress-gcp-infra
```

### 2. Create a terraform.tfvars file

Create a `terraform.tfvars` file with your specific variables:

```hcl
# General GCP settings
project_id        = "your-gcp-project-id"
region            = "us-central1"
zones             = ["us-central1-a", "us-central1-b", "us-central1-c"]

# VPC and networking
vpc_name          = "wordpress-vpc"
subnet_name       = "wordpress-subnet"
subnet_cidr       = "10.0.0.0/20"
subnet_range      = "10.1.0.0/16"

# GKE cluster
cluster_name      = "wordpress-cluster"
node_count        = 1
machine_type      = "e2-medium"
min_node_count    = 1
max_node_count    = 3
disk_size_gb      = 100
service_account   = "your-gke-service-account@your-project-id.iam.gserviceaccount.com"

# DNS
domain_name       = "example.com"
dns_zone_name     = "example-zone"
record_name       = "www"

# Load balancer
backend_service_name = "wordpress-backend"
health_check_name    = "wordpress-health-check"

# Database
db_instance_name   = "wordpress-db-instance"
database_name      = "wordpress"
db_user_name       = "wordpress-user"
```

### 3. Initialize and apply Terraform

```bash
terraform init
terraform plan
terraform apply
```

### 4. Run the WordPress setup script

```bash
chmod +x scripts/setup-wordpress.sh
./scripts/setup-wordpress.sh
```

### 5. Configure your domain registrar

After deployment, configure your domain registrar to use the Google Cloud DNS nameservers. You can find the nameservers in the Google Cloud Console or by running:

```bash
terraform output dns_name_servers
```

## Accessing WordPress

Once deployed, your WordPress site will be available at:

```
https://www.example.com
```

The WordPress admin interface will be at:

```
https://www.example.com/wp-admin/
```

## Maintenance and Operations

### Scaling WordPress

To scale the WordPress deployment, modify the `replicas` value in `kubernetes/wordpress-deployment.yaml` and reapply the manifest:

```bash
kubectl apply -f kubernetes/wordpress-deployment.yaml
```

### Database Backups

Cloud SQL automatically creates backups for your WordPress database. You can adjust the backup configuration in the `modules/database/main.tf` file.

### Updating WordPress

To update the WordPress version, modify the image tag in `kubernetes/wordpress-deployment.yaml` and reapply the manifest:

```yaml
image: wordpress:latest  # Change to specific version like wordpress:6.1
```

### SSL Certificate Management

The infrastructure uses Google-managed SSL certificates. To update domains or add new certificates, modify `kubernetes/wordpress-certificate.yaml`.

## Cost Optimization

The default configuration is designed for a production-ready WordPress site. For development environments or cost optimization, consider:

1. Reducing the GKE node machine type to `e2-small`
2. Lowering `min_node_count` to 1 and `max_node_count` to 2
3. Using a smaller instance type for Cloud SQL (`db-f1-micro` for dev/test)
4. Reducing disk sizes for both GKE nodes and Cloud SQL

## Security Considerations

- Database credentials are stored in Secret Manager and Kubernetes Secrets
- SSL/TLS encryption is enabled for the website
- Private cluster configuration reduces attack surface
- Regular updates to WordPress and plugins are recommended
- Consider enabling Cloud Armor for additional protection

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [Google Kubernetes Engine Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [Cloud SQL for MySQL Documentation](https://cloud.google.com/sql/docs/mysql)
- [WordPress on GKE Best Practices](https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-disk)
- [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
