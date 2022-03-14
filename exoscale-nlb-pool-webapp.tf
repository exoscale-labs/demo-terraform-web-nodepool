data "exoscale_compute_template" "ubuntu" {
  zone = var.zone
  name = "Linux Ubuntu 20.04 LTS 64-bit"
}

resource "exoscale_security_group" "web" {
  name        = "web-traffic"
  description = "Allows traffic for web"
}

resource "exoscale_security_group_rule" "web_rule" {
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 80
  end_port          = 80
  cidr              = "0.0.0.0/0"
  security_group_id = exoscale_security_group.web.id
}

variable "customer" {
  default = " "
  description = "name of the customer"
}

resource "exoscale_instance_pool" "webapp" {
  zone = var.zone
  name = "my-web-app"
  size = 3
  template_id = data.exoscale_compute_template.ubuntu.id
  instance_type = "standard.small"
  disk_size = 20
  instance_prefix = "my-web-app"
  security_group_ids = [exoscale_security_group.web.id]
  user_data = templatefile("scripts/webserver.yaml", { customer: var.customer })

  labels = {
    app = "webapp"
    env = "prod"
  }

  timeouts {
    delete = "10m"
  }
}

resource "exoscale_nlb" "website" {
  zone = var.zone
  name = "website"
  description = "This is the Network Load Balancer for my website"

  labels = {
    env = "prod"
  }
}

resource "exoscale_nlb_service" "website" {
  zone             = exoscale_nlb.website.zone
  name             = "website-http"
  description      = "Website over HTTP"
  nlb_id           = exoscale_nlb.website.id
  instance_pool_id = exoscale_instance_pool.webapp.id
    protocol       = "tcp"
    port           = 80
    target_port    = 80
    strategy       = "round-robin"

  healthcheck {
    mode     = "http"
    port     = 80
    uri      = "/"
    interval = 5
    timeout  = 3
    retries  = 1
  }
}

output "website-ip" {
  value = exoscale_nlb.website.ip_address
}
