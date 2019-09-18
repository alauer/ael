variable "tenancy_ocid" {
  type    = "string"
  default = "ocid1.tenancy.oc1..aaaaaaaaxiyqzsor6zpvmjhvelqx4nbm2dtxozzzpd5akauu5gqxaxdat2la"
}

variable "user_ocid" {
  type    = "string"
  default = "ocid1.user.oc1..aaaaaaaaxs4wcal2ojg456jlglo4ma3j6sssyvik5p2bycfjpwtushmav4tq"

}

variable "fingerprint" {
  type    = "string"
  default = "cd:77:a4:14:fd:0c:73:c8:06:af:86:04:68:63:fd:ee"
}

variable "private_key_path" {
  type    = "string"
  default = "~/.ssh/id_rsa"
}

variable "compartment_id" {
  type    = "string"
  default = "ocid1.tenancy.oc1..aaaaaaaaxiyqzsor6zpvmjhvelqx4nbm2dtxozzzpd5akauu5gqxaxdat2la"
}


provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "us-ashburn-1"
  alias            = "iad"
}

provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "us-phoenix-1"
  alias            = "phx"
}

resource "oci_core_vcn" "ael_iad_vcn" {
  provider       = oci.iad
  cidr_block     = "10.200.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "ael-iad-vcn"
}

resource "oci_core_subnet" "ael_iad_vcn_subnet1" {
  provider       = oci.iad
  cidr_block     = "10.200.1.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.ael_iad_vcn.id
  display_name   = "subnet1"
}

resource "oci_core_drg" "ael_iad_drg" {
  provider = oci.iad
  #Required
  compartment_id = var.compartment_id

  #Optional
  display_name = "ael-iad-drg"
}

resource "oci_core_drg_attachment" "ael_iad_drgattach" {
  provider = oci.iad
  drg_id   = oci_core_drg.ael_iad_drg.id
  vcn_id   = oci_core_vcn.ael_iad_vcn.id
}

resource "oci_core_vcn" "ael_phx_vcn" {
  provider       = oci.phx
  cidr_block     = "10.201.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "ael-phx-vcn"
}

resource "oci_core_subnet" "ael_phx_vcn_subnet1" {
  provider       = oci.phx
  cidr_block     = "10.201.1.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.ael_phx_vcn.id
  display_name   = "subnet1"
}

resource "oci_core_drg" "ael_phx_drg" {
  provider = oci.phx
  #Required
  compartment_id = var.compartment_id

  #Optional
  display_name = "ael-phx-drg"
}

resource "oci_core_drg_attachment" "ael_phx_drgattach" {
  provider = oci.phx
  drg_id   = oci_core_drg.ael_phx_drg.id
  vcn_id   = oci_core_vcn.ael_phx_vcn.id
}
