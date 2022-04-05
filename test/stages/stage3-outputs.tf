
 resource null_resource write_outputs {
   provisioner "local-exec" {
     command = "echo \"$${OUTPUT}\" > gitops-output.json"

     environment = {
       OUTPUT = jsonencode({
         name        = module.cp-waiops-infra-automation.name
         branch      = module.cp-waiops-infra-automation.branch
         layer       = module.cp-waiops-infra-automation.layer
         layer_dir   = module.cp-waiops-infra-automation.layer == "infrastructure" ? "1-infrastructure" : (module.cp4s.layer == "services" ? "2-services" : "3-applications")
         type        = module.cp-waiops-infra-automation.type
       })
     }
   }
}