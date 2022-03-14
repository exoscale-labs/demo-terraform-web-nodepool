terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.31"
    }


    }
}

# Configure Exoscale provider
provider "exoscale" {
  config = "cloudstack.ini"

  timeout = 300          # default: waits 60 seconds in total for a resource
}