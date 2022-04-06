module "gitops_cp_waiops_infra_automation" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = module.cp_catalogs_waiops.entitlement_key
  catalog_source_name = module.cp_catalogs_waiops.catalog_ibmoperators_waiops_aimgr
  storageClass = var.storageClass
}