locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#sscs")
    )}"
}
