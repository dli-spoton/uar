terraform {
  required_version = ">= 1.3"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 3.20"
    }
    local = {
      source  = "hashicorp/local"
      version = "= 2.3.0"
    }
  }
}
