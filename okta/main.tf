
data "okta_users" "active" {
  search {
    expression = "status lt \"DEPROVISIONED\" or status gt \"DEPROVISIONED\""
  }
  include_groups = false
  include_roles  = false
}

locals {
  date = formatdate("YYMMDD", timestamp())
  csv_list = concat(
    ["Full Name, First, Last, Login, Email, Manager, Manager Email, Status"],
    [for i in data.okta_users.active.users : "\"${i.display_name}\",\"${i.first_name}\",\"${i.last_name}\",\"${i.login}\",\"${i.email}\",\"${i.manager}\",\"${i.manager_id}\",\"${i.status}\""],
  )
  csv_content = join("\n", local.csv_list)
}

resource "local_file" "csv" {
  content  = local.csv_content
  filename = "${path.module}/output/okta_spoton_users_${local.date}.csv"
}
