terraform {
  //  backend "s3" {
  //    bucket = "ael-demo-tf-statefiles"
  //    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-pureport.tfstate"
  //    region = "us-east-1"
  //  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "multicloud-demo-pureport"
    }
  }
}

provider "pureport" {
  api_key    = "73XrDMJd5nKko"
  api_secret = "gEf2eRV2BVEAsywz8"
  api_url    = "https://api.pureport.com"
  alias      = "terraform-testing"
}

/*
curl -X POST https://api.pureport.com/login \
    -H "Content-Type: application/json" \
    -d '{
        "key": "73XrDMJd5nKko",
        "secret": "gEf2eRV2BVEAsywz8"
    }'
*/

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
  name_regex   = "test-network-ael"
}
