data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.net_backet_remote_state
    key    = var.net_key_remote_state
    region = var.net_remote_state_region
  }
}

locals {
  net_vpc_id = matchkeys([data.terraform_remote_state.network.outputs.vpc.vpc.id],
    [data.terraform_remote_state.network.outputs.vpc.vpc.tags.Name],
  var.net_vpc_name)[0]
}

resource "aws_lb_target_group" "lb_tg" {
  name     = var.lb_name
  port     = var.lb_port
  protocol = var.lb_protocol
  vpc_id   = local.net_vpc_id
}
