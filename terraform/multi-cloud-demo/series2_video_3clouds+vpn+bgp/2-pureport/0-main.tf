terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "multicloud-demo-pureport"
    }
  }
}

provider "pureport" {
  api_key    = var.pureport_api_key
  api_secret = var.pureport_api_secret
  api_url    = "https://api.pureport.com"
  alias      = "terraform-testing"
}

data "pureport_accounts" "main" {
  provider = pureport.terraform-testing

  //name     = "AaronCo*"
  filter {
    name   = "Name"
    values = ["AaronCo"]
  }
}

data "pureport_locations" "iad" {
  provider = pureport.terraform-testing
  filter {
    name   = "Name"
    values = ["Washington, DC"]
  }
}

data "pureport_locations" "sjc" {
  provider = pureport.terraform-testing
  filter {
    name   = "Name"
    values = ["Dallas, TX"]
  }
}

data "pureport_networks" "main" {
  provider     = pureport.terraform-testing
  account_href = data.pureport_accounts.main.accounts[0].href
  filter {
    name   = "Name"
    values = ["ael-soleng-demo"]
  }
}

data "terraform_remote_state" "cloudinfra" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "SolEng"
    workspaces = {
      name = "multicloud-video-cloudinfra"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}
