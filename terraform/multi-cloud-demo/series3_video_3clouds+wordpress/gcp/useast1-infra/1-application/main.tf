terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "multicloud-demo-3-gcpapp"
    }
  }
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

data "terraform_remote_state" "rds" {
  backend = "remote"

  config {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "multicloud-demo-3-application"
    }
  }
}

data "template_file" "test" {
  template = <<EOF
#cloud-config
package_update: true

runcmd:
  - /usr/bin/docker run --name wordpress -p 80:80 -e WORDPRESS_DB_HOST=${data.terraform_remote_state.rds.rds_cluster_endpoint}:3306 -e WORDPRESS_DB_PASSWORD=${data.terraform_remote_state.rds.rds_cluster_master_password} -e WORDPRESS_CONFIG_EXTRA="define('WP_SITEURL', 'http://'); define('WP_HOME', 'http://');" --restart unless-stopped -d wordpress:latest

output:
  all: '| tee -a /var/log/cloud-init-output.log'
EOF
}

locals {
  pureport_network = ["10.20.0.0/16", "10.33.133.0/24", "10.10.10.0/24", "172.16.0.0/16"]
  office_ip = "136.41.224.23/32"
  project = "pureport-sol-eng-1"
  region = "us-east4"
}

provider "google" {
  credentials = "${file("/Users/alauer/.gcloud/pureport-sol-eng-1-1f4c0aed51c7.json")}"
  project = "${local.project}"
  region = "${local.region}"
  version = "~> 2.5"
}

resource "google_compute_instance" "wordpress" {
  name = "ael-wordpress-demo-1"
  machine_type = "f1-micro"
  zone = "${local.region}-c"
  project = "${local.project}"

  boot_disk {
    initialize_params {
      size = 10
      type = "pd-standard"
      image = "projects/pureport-sol-eng-1/global/images/ael-wordpress-image-1"
    }
  }

  network_interface {
    subnetwork = "${data.terraform_remote_state.pureport.subnets_self_links[0]}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    user-data = "${data.template_file.test.rendered}"
  }
}

resource "google_compute_firewall" "wordpress" {
  name = "wordpress-demo-pureport"
  network = "${data.terraform_remote_state.pureport.network_self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["80", "22"]
  }
}
