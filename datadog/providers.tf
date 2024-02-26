
variable "datadog_credentials" {
  type = object({
    api_key = string
    app_key = string
  })
}

# Configure the Datadog provider
provider "datadog" {
  api_key = var.datadog_credentials.api_key
  app_key = var.datadog_credentials.app_key

}
