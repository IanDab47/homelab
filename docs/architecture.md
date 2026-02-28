# Architecture

This chapter describes the overall architecture of the homelab.

```mermaid
graph TD
    Internet -->|WAN| Firewall[Firewall / Gateway]
    Firewall --> LAN[Internal Network 10.0.0.0/24]
    LAN -->|VLAN 10| Server[Proxmox Host]
    LAN -->|VLAN 20| Desktop[Personal Desktop]