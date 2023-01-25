# Intersight Policies Module

This module creates various pools, policies, a UCS server profile template, and a UCS domain profile. 

This policy bundle creates the following Intersight server pools:
- IP-pool
- MAC-pool
- WWNN-pool
- WWPN-A-pool
- WWPN-B-pool

This policy bundle creates the following Intersight server policies:
- Boot order
- NTP
- Network connectivity (dns)
- Multicast
- Virtual KVM (enable KVM)
- Virtual Media
- System QoS
- IMC Access
- LAN connectivity
- VLAN
- Port (FI port policy)
- Ethernet Network Group
- Ethernet Adapter
- Ethernet QoS

This policy bundle creates a single Intersight server template based on the above pools and policies.

This policy bundle creates a single Intersight UCS domain profile based on the above pools and policies.


### Change the following settings to meet your needs

Go into variables.tf and edit the default starting point to match what you would like to have in your environment. Otherwise you will end up with the following defaulted pools:

1. ip-pool from 1.1.1.101 -- 199
2. mac-pool from 00:CA:FE:00:00:01 -- 00:CA:FE:00:00:FF
3. wwnn-pool from 20:00:00:CA:FE:00:00:01 -- 20:00:00:CA:FE:00:00:FF
4. wwpn-a-pool from 20:00:00:CA:FE:0A:00:01 -- 20:00:00:CA:FE:0A:00:FF
5. wwpn-b-pool from 20:00:00:CA:FE:0B:00:01 -- 20:00:00:CA:FE:0B:00:FF


### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are used by the the UCS domain profile. To get around this, you will have to delete the domain profile manually and possibly any server profiles that are using any of the profiles or policies created.

This is basically a copy of https://github.com/terraform-cisco-modules/terraform-intersight-policy-bundle with a removal of the policy-diskgroup and addition of the pool creation.