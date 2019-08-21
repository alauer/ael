terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "connectyourcare-pureport"
    }
  }
}

provider "pureport" {
  api_key    = var.pureport_api_key
  api_secret = var.pureport_api_secret
  api_url    = "https://api.pureport.com"
  alias      = "terraform-demo"
}

data "pureport_accounts" "main" {
  provider = pureport.terraform-demo

  //name     = "AaronCo*"
  filter {
    name   = "Name"
    values = ["AaronCo"]
  }
}

data "pureport_locations" "chi" {
  provider = pureport.terraform-demo
  filter {
    name   = "Name"
    values = ["Chicago, IL"]
  }
}

data "pureport_locations" "sjc" {
  provider = pureport.terraform-demo
  filter {
    name   = "Name"
    values = ["Dallas, TX"]
  }
}

data "pureport_networks" "main" {
  provider     = pureport.terraform-demo
  account_href = data.pureport_accounts.main.accounts[0].href
  filter {
    name   = "Name"
    values = ["ConnectYourCare"]
  }
}

data "terraform_remote_state" "cloudinfra" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "SolEng"
    workspaces = {
      name = "rancher-multicloud-infra"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "usw2"
}

provider "aws" {
  region = "us-west-1"
  alias  = "usw1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "use2"
}
