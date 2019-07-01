//terraform {
//  backend "s3" {
//    bucket = "ael-demo-tf-statefiles"
//    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-dx.tfstate"
//    region = "us-east-1"
//  }
//}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "multicloud-demo-1-dx"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "euw1"
}

data "terraform_remote_state" "pureport" {
  backend = "remote"

  config {
    organization = "SolEng"

    workspaces {
      name = "multicloud-demo-pureport"
    }
  }
}

module "dxg" {
  source = "/Users/alauer/Documents/GitHub/solutions-engineering/terraform/modules/pureport_dxg"

  providers = {
    aws = "aws.use1"
  }

  region = "us-east-1"

  directconnect_primary_id   = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.0.remote_id}"
  directconnect_secondary_id = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.1.remote_id}"
  dxg_name                   = "ael-dxg-us-east-1-terraform"
  bgp_auth_key_primary       = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.0.bgp_password}"
  bgp_auth_key_secondary     = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.1.bgp_password}"
  bgp_pureport_asn           = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.0.pureport_asn}"
  pureport_vlan_primary      = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.0.vlan}"
  pureport_vlan_secondary    = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.1.vlan}"
  bgp_pureport_ip_primary    = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.0.pureport_ip}"
  bgp_amazon_ip_primary      = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.0.customer_ip}"
  bgp_pureport_ip_secondary  = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.1.pureport_ip}"
  bgp_amazon_ip_secondary    = "${data.terraform_remote_state.pureport.ael_use1_terraform_lab.1.customer_ip}"

  tags = {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "1-dx"
  }
}
