terraform {
  required_version = ">= 1.3"
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.36.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "= 3.4.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "= 2.4.1"
    }
  }
}
