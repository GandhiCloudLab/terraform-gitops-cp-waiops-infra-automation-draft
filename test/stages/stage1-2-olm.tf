

#divya -- added this as OLM is required
module "olm" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-olm" 
  cluster_config_file = module.dev_cluster.config_file_path
  cluster_type = module.dev_cluster.platform.type_code
  cluster_version = module.dev_cluster.platform.version

}
