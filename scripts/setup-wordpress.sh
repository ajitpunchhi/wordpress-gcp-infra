#!/bin/bash
# scripts/setup-wordpress.sh

# Set variables from Terraform outputs
PROJECT_ID=$(terraform output -raw project_id)
REGION=$(terraform output -raw region)
CLUSTER_NAME=$(terraform output -raw cluster_name)
DATABASE_HOST=$(terraform output -raw database_ip)
DATABASE_NAME=$(terraform output -raw database_name)
DATABASE_USER=$(terraform output -raw db_user_name)
SECRET_ID=$(terraform output -raw secret_id)

# Get database password from Secret Manager
DATABASE_PASSWORD=$(gcloud secrets versions access latest --secret=$SECRET_ID --format='get(payload.data)' | base64 -d | jq -r '.password')

# Configure kubectl to connect to the GKE cluster
gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID

# Create the Kubernetes secret for WordPress database credentials
cat <<EOF > kubernetes/wordpress-db-secret-values.yaml
apiVersion: v1
kind: Secret
metadata:
  name: wordpress-db-secret
type: Opaque
stringData:
  host: $DATABASE_HOST
  database: $DATABASE_NAME
  username: $DATABASE_USER
  password: $DATABASE_PASSWORD
EOF

# Apply Kubernetes manifests
kubectl apply -f kubernetes/wordpress-db-secret-values.yaml
kubectl apply -f kubernetes/wordpress-pvc.yaml
kubectl apply -f kubernetes/wordpress-deployment.yaml
kubectl apply -f kubernetes/wordpress-service.yaml
kubectl apply -f kubernetes/wordpress-certificate.yaml
kubectl apply -f kubernetes/wordpress-ingress.yaml

# Wait for WordPress to be ready
echo "Waiting for WordPress deployment to be ready..."
kubectl rollout status deployment/wordpress

echo "WordPress deployed successfully!"
echo "It may take a few minutes for the load balancer and DNS to propagate."
echo "Website URL: https://$(terraform output -raw website_url)"