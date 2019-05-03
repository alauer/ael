terraform {
  backend "local" {
    path = "./terraform-intercon.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config {
    path = "../1-vpc/terraform-vpc.tfstate"
  }
}

provider "google" {
  credentials = "${file("/Users/alauer/.gcloud/pureport-sol-eng-1-1f4c0aed51c7.json")}"
  project     = "pureport-sol-eng-1"
  region      = "us-east4"
  version     = "~> 2.5"
}

locals {
  pureport_network = ["10.20.0.0/16", "10.33.133.0/24"]
  office_ip        = "136.41.224.23/32"
  region1          = "us-west1"
  region2          = "us-central1"
}

resource "google_compute_interconnect_attachment" "pureport1" {
  name                     = "ael-demoaf-${local.region1}-vlan1"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  region                   = "${local.region1}"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router1}"
}

resource "google_compute_interconnect_attachment" "pureport2" {
  name                     = "ael-demoaf-${local.region1}-vlan2"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  region                   = "${local.region1}"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router2}"
}

resource "google_compute_interconnect_attachment" "pureport3" {
  name                     = "ael-demoaf-${local.region2}-vlan1"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  region                   = "${local.region2}"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router3}"
}

resource "google_compute_interconnect_attachment" "pureport4" {
  name                     = "ael-demoaf-${local.region2}-vlan2"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  region                   = "${local.region2}"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router4}"
}
