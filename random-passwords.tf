resource "random_string" "admin-password" {
  length = 16
  special = true
  override_special = "/@\" "
}
