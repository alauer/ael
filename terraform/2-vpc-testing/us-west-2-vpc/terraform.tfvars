aws_region = "us-west-2"
office_ip = "136.41.224.23/32"

vpc1_name = "ael-kb-test1"
vpc1_cidr = "10.0.0.0/16"
vpc1_public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

vpc2_name = "ael-kb-test2"
vpc2_cidr = "10.10.0.0/16"
vpc2_public_subnets  = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]

dx_connection_id_primary = ""
dx_connection_id_secondary = ""
bgp_pureport_asn = "394351"
bgp_auth_key_primary = "bh3knqcdlMaW4qLD3LOi4"
bgp_auth_key_secondary = "MbHKTLsxvdauWNyAFV1WO"
pureport_vlan_primary = "343"
pureport_vlan_secondary = "311"


resource_group_name = "us-west2-dev"
