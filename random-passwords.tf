resource "random_string" "admin_password" {
  length = 16
  special = true
  override_special = "/@\" "
}
