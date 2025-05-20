# main.tf - Root configuration

# Create the VPC and networking components
module "networking" {
  source = "./modules/networking"

  project_id   = var.project_id
  region       = var.region
  vpc_name     = var.vpc_name
  subnet_name  = var.subnet_name
  subnet_cidr  = var.subnet_cidr
  subnet_range = var.subnet_range
}

# Create the GKE cluster
module "gke" {
  source = "./modules/gke"

  project_id      = var.project_id
  region          = var.region
  zones           = var.zones
  network_name    = module.networking.vpc_name
  subnet_name     = module.networking.subnet_name
  cluster_name    = var.cluster_name
  node_count      = var.node_count
  machine_type    = var.machine_type
  min_node_count  = var.min_node_count
  max_node_count  = var.max_node_count
  disk_size_gb    = var.disk_size_gb
  service_account = var.service_account

  depends_on = [module.networking]
}

# Configure DNS
module "dns" {
  source = "./modules/dns"

  project_id     = var.project_id
  domain_name    = var.domain_name
  dns_zone_name  = var.dns_zone_name
  record_name    = var.record_name
  load_balancer_ip = module.load_balancer.load_balancer_ip

  depends_on = [module.load_balancer]
}

# Configure Load Balancer
module "load_balancer" {
  source = "./modules/load_balancer"

  project_id     = var.project_id
  region         = var.region
  network_name   = module.networking.vpc_name
  backend_service_name = var.backend_service_name
  health_check_name = var.health_check_name
  
  depends_on = [module.gke, module.networking]
}

# Create MySQL Database for WordPress
module "database" {
  source = "./modules/database"

  project_id      = var.project_id
  region          = var.region
  instance_name   = var.db_instance_name
  database_name   = var.database_name
  user_name       = var.db_user_name
  network_name    = module.networking.vpc_name

  depends_on = [module.networking]
}