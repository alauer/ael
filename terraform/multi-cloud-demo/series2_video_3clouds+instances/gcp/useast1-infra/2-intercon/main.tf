terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-gcp-intercon.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-gcp.tfstate"
    region = "us-east-1"
  }
}

provider "google" {
  credentials = "${file("/Users/alauer/.gcloud/pureport-sol-eng-1-1f4c0aed51c7.json")}"
  project     = "pureport-sol-eng-1"
  region      = "us-east4"
  version     = "~> 2.5"
  alias       = "gce"
}

locals {
  pureport_network = ["10.20.0.0/16", "10.33.133.0/24", "10.10.10.0/24", "172.16.0.0/16"]
  office_ip        = "136.41.224.23/32"
  region           = "us-east4"
}

resource "google_compute_interconnect_attachment" "pureport1" {
  name                     = "ael-wordpress-vlan1"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router1}"
}

resource "google_compute_interconnect_attachment" "pureport2" {
  name                     = "ael-wordpress-vlan2"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router2}"
}
