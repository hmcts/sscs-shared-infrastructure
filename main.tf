locals {
  tags = "${merge(var.common_tags,
    map("Team Name", "${var.team_name}"),
    map("Team Contact", "#sscs")
    )}"
}