terraform {
  backend "local" {
    path = "./terraform-vpc.tfstate"
  }
}

provider "google" {
  credentials = "${file("/Users/alauer/.gcloud/pureport-sol-eng-1-1f4c0aed51c7.json")}"
  project     = "pureport-sol-eng-1"
  region      = "us-west1"
  version     = "~> 2.5"
}

locals {
  pureport_network = ["10.20.0.0/16", "10.33.133.0/24"]
  office_ip        = "136.41.224.23/32"
  region1          = "us-west1"
  region2          = "us-central1"
}

module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = "pureport-sol-eng-1"
  network_name = "ael-af-demo"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "west1-demoaf"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "${local.region1}"
    },
    {
      subnet_name   = "central1-demoaf"
      subnet_ip     = "10.10.11.0/24"
      subnet_region = "${local.region2}"
    },
  ]

  secondary_ranges = {
    west1-demoaf    = []
    central1-demoaf = []
  }
}

resource "google_compute_router" "pureport1" {
  name    = "ael-demoaf-westrouter1"
  network = "${module.vpc.network_name}"
  region  = "${local.region1}"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router" "pureport2" {
  name    = "ael-demoaf-westrouter2"
  network = "${module.vpc.network_name}"
  region  = "${local.region1}"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router" "pureport3" {
  name    = "ael-demoaf-centralrouter1"
  network = "${module.vpc.network_name}"
  region  = "${local.region2}"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router" "pureport4" {
  name    = "ael-demoaf-centralrouter2"
  network = "${module.vpc.network_name}"
  region  = "${local.region2}"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}
