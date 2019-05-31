provider "google" {
  credentials = "${file("/Users/alauer/.gcloud/pureport-sol-eng-1-1f4c0aed51c7.json")}"
  project     = "pureport-sol-eng-1"
  region      = "us-east4"
  version     = "~> 2.5"
  alias       = "gce"
}

resource "google_compute_interconnect_attachment" "pureport1" {
  provider                 = "google.gce"
  name                     = "ael-wordpress-vlan1"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router1}"
}

resource "google_compute_interconnect_attachment" "pureport2" {
  provider                 = "google.gce"
  name                     = "ael-wordpress-vlan2"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  router                   = "${data.terraform_remote_state.vpc.vpc_cloud_router2}"
}

module "vpc" {
  source = "terraform-google-modules/network/google"

  providers = {
    google = "google.gce"
  }

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
  provider = "google.gce"
  name     = "ael-wordpress-router1"
  network  = "${module.vpc.network_name}"
  region   = "us-east4"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_router" "pureport2" {
  provider = "google.gce"
  name     = "ael-wordpress-router2"
  network  = "${module.vpc.network_name}"
  region   = "us-east4"

  bgp {
    asn            = "16550"
    advertise_mode = "DEFAULT"
  }
}
