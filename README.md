# wireguard provisioning

## motivation

Based on
[this](https://projects.freifunk.net/#/projects?project=libremesh_librenet6_integrations&lang=en)
Freifunk project proposal I'd summarize the following two requirements of
existing mesh communities:

* Public IPv4 & IPv6 addresses to nodes in a mesh network
* Remote access to nodes (if desired) to help non-technical users

Optional:

* Encrypted traffic to a trusted gateway over an unencrypted wireless mesh network

## Idea

Nodes are pre setup with the address and credentials of a VPN server. On node
boot a VPN client is configured and tries to connect to the VPN server.

The VPN server should be very simple to setup and allow configuration of IPv4/6
forwarding to connected clients, also allow *NAT* for specified addresses.

## Possible technology

### VPN part

[Wireguard](https://wireguard.com) could solve this issue with minimal
configuration hassle, low storage impact on nodes and good bandwidth
performance when used for uplink connections.

Problem is the negotiation of addresses as *wireguard* does not support DHCP
for clients like other VPN services may do. Automatic IP provisioning is
required.

As the public key of the server is preset there is no risk of MITM attacks. So
the clients process of receiving it IP address(es) doesn't require special
security measures.

The VPN server interface would allow administrators to automatically assign
free addresses to connecting nodes or set specific addresses to known public
key of clients.

### Internal mesh routing

Assigning public addresses to hosts via a VPN can result in unnecessary routing as
two connecting nodes use the VPN as gateway which traffic is then forwarded to
the VPNs client node. This could drastically slow down internal mesh
connection.
A possible solution for this problem is to let the used mesh routing protocol
announce it's public IP address to the rest of the mesh network. A simple
configuration of this is found in the package
[lime-proto-bmx7](https://github.com/libremesh/lime-packages/blob/develop/packages/lime-proto-bmx7/src/bmx7.lua#L35).

## Possible implementation

### Manual assignment

Currently just a shell script running on the VPN server which should be
a OpenWrt node.

The server hosts all content of `./public` with disabled *autoindex*.
Client will generate a fresh wireguard private key on first boot and tries to
fetch a free ip from `vpn ip`/`sha256 of pubkey`. On success the client
setups wireguard and starts using it. On fail, retry after *x*.

The clients public key could be shown in a simplified web interface like
[lime-app](https://github.com/libremesh/lime-app/) and allow the users to
request vpn access by the vpn provider.

This approach could provide people *secure connections* (to a gateway) within
an unencrypted mesh network and public IPv{4,6} provided by the gateway.

### Automatic assignment

tba

### server

* `WIREGUARD_IP`: ip for the wireguard interface with subnet
* `WIREGUARD_CLIENTS`: (generated) file which contain the ips + public key
* `PRIVATE_KEY`: guess

#### usage

* set an adequate ip in `WIREGUARD_IP`
* run `./wg-pro.sh` to create an initial config file
* edit `WIREGUARD_CLIENTS` adding public keys of clients (and may comments)
* run `./wg-pro.sh` again to create `uci` config and fill `./public` folder

### client

**tba**

