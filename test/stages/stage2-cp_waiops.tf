module "gitops_cp-waiops-infra-automation" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = var.entitlement_key
  cp_waiops_storageClass = var.cp_waiops_storageClass
  cp_waiops_storageClassLargeBlock = var.cp_waiops_storageClassLargeBlock
}