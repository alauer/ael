terraform {
  backend "s3" {
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
}

locals {
  pureport_network = ["10.20.0.0/16", "10.33.133.0/24"]
  office_ip        = "136.41.224.23/32"
  region           = "us-east4"
}

module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = "pureport-sol-eng-1"
  network_name = "ael-wordpress-demo"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "wordpress1"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "${local.region}"
    },
  ]

  secondary_ranges = {
    wordpress1 = []
  }
}

resource "google_compute_router" "pureport1" {
  name    = "ael-wordpress-router1"
  network = "${module.vpc.network_name}"
  region  = "${local.region}"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router" "pureport2" {
  name    = "ael-wordpress-router2"
  network = "${module.vpc.network_name}"
  region  = "${local.region}"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_interconnect_attachment" "pureport1" {
  name                     = "ael-wordpress-vlan1"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  router                   = "${google_compute_router.pureport1.self_link}"
}

resource "google_compute_interconnect_attachment" "pureport2" {
  name                     = "ael-wordpress-vlan2"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  router                   = "${google_compute_router.pureport2.self_link}"
}
