
# get all users
data "datadog_users" "all" {}

locals {
  user_ids = {
    for each in data.datadog_users.all.users : each.email => each.id
  }
}

# get all user details
data "http" "users" {
  for_each = local.user_ids
  url      = "https://api.datadoghq.com/api/v2/users/${each.value}"

  request_headers = {
    Accept             = "application/json"
    DD-API-KEY         = var.datadog_credentials.api_key
    DD-APPLICATION-KEY = var.datadog_credentials.app_key
  }
}

locals {
  response_body = {
    for k, v in data.http.users : k => jsondecode(v.response_body) if v.status_code == 200
  }
  user_data = {
    for k, v in local.response_body : k => {
      name   = v.data.attributes.name
      email  = v.data.attributes.email
      status = v.data.attributes.status
      roles = [
        for i in v.included : i.attributes.name if i.type == "roles"
      ]
    }
  }
}

locals {
  date = formatdate("YYMMDD", timestamp())
  csv_list = concat(
    ["Name, Email, Status, Roles"],
    [for i in local.user_data : "\"${try(coalesce(i.name), "")}\",\"${i.email}\",\"${i.status}\",\"${join(", ", i.roles)}\""],
  )
  csv_content = join("\n", local.csv_list)
}

resource "local_file" "csv" {
  content  = local.csv_content
  filename = "${path.module}/output/dd_users_${local.date}.csv"
}

output "failed" {
  value = {
    for k, v in data.http.users : k => {
      status_code      = v.status_code
      response_headers = v.response_headers
    } if v.status_code != 200
  }
}
