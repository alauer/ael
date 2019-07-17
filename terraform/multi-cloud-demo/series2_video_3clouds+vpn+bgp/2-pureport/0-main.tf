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
  api_key    = "${var.pureport_api_key}"
  api_secret = "${var.pureport_api_secret}"
  api_url    = "https://api.pureport.com"
  alias      = "terraform-testing"
}

data "pureport_accounts" "main" {
  provider   = "pureport.terraform-testing"
  name_regex = "AaronCo"
}

data "pureport_locations" "iad" {
  provider   = "pureport.terraform-testing"
  name_regex = "^Wash*"
}

data "pureport_locations" "sjc" {
  provider   = "pureport.terraform-testing"
  name_regex = "^Silicon*"
}

data "pureport_networks" "main" {
  provider     = "pureport.terraform-testing"
  account_href = "${data.pureport_accounts.main.accounts.0.href}"
  name_regex   = "ael-soleng-demo"
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
