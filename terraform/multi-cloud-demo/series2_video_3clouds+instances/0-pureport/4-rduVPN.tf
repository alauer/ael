resource "pureport_site_vpn_connection" "raleigh-lab" {
  provider            = "pureport.terraform-testing"
  name                = "ael-vpn-raleigh-lab"
  speed               = "100"
  high_availability   = true
  enable_bgp_password = true

  location_href = "${data.pureport_locations.iad.locations.0.href}"
  network_href  = "${data.pureport_networks.main.networks.0.href}"

  ike_version = "V2"

  ike_config {
    esp {
      dh_group   = "MODP_2048"
      encryption = "AES_128"
      integrity  = "SHA256_HMAC"
    }

    ike {
      dh_group   = "MODP_2048"
      encryption = "AES_128"
      integrity  = "SHA256_HMAC"
    }
  }

  routing_type = "ROUTE_BASED_BGP"

  customer_asn = 65001

  primary_customer_router_ip   = "136.56.60.22"
  secondary_customer_router_ip = "136.56.60.22"
}

/*
resource "local_file" "saved-manifesto" {
  content = "${data.template_file.cluster-manifesto.rendered}"
  filename = "${local.cluster_manifesto_path}"
}

data "template_file" "panos" {
  template = "${file("${path.module}/panos.tpl")}"
  vars = {
    local_address_primary = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.customer_ip}"
    local_address_secondary = "${pureport_site_vpn_connection.raleigh-lab.gateways.1.customer_ip}"
    peer_address_primary = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.pureport_ip}"
    peer_address_secondary = "${pureport_site_vpn_connection.raleigh-lab.gateways.1.pureport_ip}"
    pre_shared_key_primary = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.vpn_auth_key}"
    pre_shared_key_secondary = "${pureport_site_vpn_connection.raleigh-lab.gateways.1.vpn_auth_key}"
    local_as = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.customer_asn}"
    peer_as = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.pureport_asn}"
    bgp_secret_primary = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.bgp_password}"
    bgp_secret_secondary = "${pureport_site_vpn_connection.raleigh-lab.gateways.1.bgp_password}"
    local_vti_address_primary = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.customer_vti_ip}"
    local_vti_address_secondary = "${pureport_site_vpn_connection.raleigh-lab.gateways.1.customer_vti_ip}"
    peer_vti_address_primary = "${pureport_site_vpn_connection.raleigh-lab.gateways.0.pureport_vti_ip}"
    peer_vti_address_secondary = "${pureport_site_vpn_connection.raleigh-lab.gateways.1.pureport_vti_ip}"

  }
}
*/

