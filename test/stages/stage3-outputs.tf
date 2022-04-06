 resource null_resource write_outputs {
   provisioner "local-exec" {
     command = "echo \"$${OUTPUT}\" > gitops-output.json"

     environment = {
       OUTPUT = jsonencode({
         name        = module.gitops_cp_waiops_infra_automation.name
         branch      = module.gitops_cp_waiops_infra_automation.branch
         layer       = module.gitops_cp_waiops_infra_automation.layer
         layer_dir   = module.gitops_cp_waiops_infra_automation.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_cp_waiops_infra_automation.layer == "services" ? "2-services" : "3-applications")
         type        = module.gitops_cp_waiops_infra_automation.type
       })
     }
   }
}