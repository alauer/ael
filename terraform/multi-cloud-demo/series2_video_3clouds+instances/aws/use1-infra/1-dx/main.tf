terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-dx.tfstate"
    region = "us-east-1"
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

module "dxg" {
  source = "/Users/alauer/Documents/GitHub/solutions-engineering/terraform/modules/pureport_dxg"

  providers = {
    aws = "aws.use1"
  }

  region = "us-east-1"

  directconnect_primary_id   = "dxcon-fgd93v1w"
  directconnect_secondary_id = "dxcon-fg9fyr4z"
  dxg_name                   = "ael-dxg-us-east-1"
  bgp_auth_key_primary       = "cHgzIo0tijY4sm1CGZ1iJ"
  bgp_auth_key_secondary     = "K5WiVwItHmW6T8cSjkB4m"
  bgp_pureport_asn           = "394351"
  pureport_vlan_primary      = "141"
  pureport_vlan_secondary    = "190"

  tags {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "1-dx"
  }
}
