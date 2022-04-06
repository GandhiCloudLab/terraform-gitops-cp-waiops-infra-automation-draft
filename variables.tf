
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
  default     = "cp4waiops"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "entitlement_key" {
  type        = string
  description = "The entitlement key used to access the waiops images in the container registry. Visit https://myibm.ibm.com/products-services/containerlibrary to get the key"
  sensitive   = true
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key for IBM Cloud access"
  default     = "default"
}

variable "storageClass" {
  type        = string
  description = "WAIOps Storage Class"
  default     = "ibmc-file-gold-gid"
}

variable "catalog_source_name" {
  type        = string
  description = "WAIOps Catalog Source"
}