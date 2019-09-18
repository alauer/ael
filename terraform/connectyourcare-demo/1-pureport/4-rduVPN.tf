
resource "pureport_site_vpn_connection" "raleigh-lab" {
  provider            = pureport.terraform-demo
  name                = "ael-vpn-raleigh-lab"
  speed               = "500"
  high_availability   = true
  enable_bgp_password = true

  location_href = "/locations/us-wdc"
  network_href  = data.pureport_networks.main.networks[0].href

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
