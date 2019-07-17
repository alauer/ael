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
  router                   = "${google_compute_router.pureport1.self_link}"

  provisioner "local-exec" {
    command = "gcloud compute interconnects attachments partner update ${google_compute_interconnect_attachment.pureport1.name} --region us-east4 --admin-enabled"
  }
}

resource "google_compute_interconnect_attachment" "pureport2" {
  provider                 = "google.gce"
  name                     = "ael-wordpress-vlan2"
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  router                   = "${google_compute_router.pureport2.self_link}"

  provisioner "local-exec" {
    command = "gcloud compute interconnects attachments partner update ${google_compute_interconnect_attachment.pureport2.name} --region us-east4 --admin-enabled"
  }
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "1.0.0"

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
      subnet_region = "us-east4"
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

resource "pureport_google_cloud_connection" "main" {
  provider = "pureport.terraform-testing"
  name     = "ael-use4gce-terraform-lab"
  speed    = "50"

  high_availability = true
  location_href     = "${data.pureport_locations.iad.locations.0.href}"
  network_href      = "${data.pureport_networks.main.networks.0.href}"

  primary_pairing_key   = "${google_compute_interconnect_attachment.pureport1.pairing_key}"
  secondary_pairing_key = "${google_compute_interconnect_attachment.pureport2.pairing_key}"
}
