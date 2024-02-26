
variable "okta_provider" {
  type = object({
    org_name    = string
    base_url    = string
    client_id   = string
    private_key = string
  })
}

provider "okta" {
  org_name    = var.okta_provider.org_name
  base_url    = var.okta_provider.base_url
  client_id   = var.okta_provider.client_id
  private_key = file(var.okta_provider.private_key)
  scopes = [
    "okta.users.read",
  ]
}
