# wireguard provisioning

## idea

Wireguard configuration for devices which only have a preset vpn ip and public
key.

The server hosts all content of `./public` with disabled *autoindex*.
Client will generate a fresh wireguard private key on first boot and tries to
fetch a free ip from `vpn ip`/`sha256 of pubkey`. On success the client
setups wireguard and starts using it. On fail, retry after *x*.

The clients public key could be shown in a simpliefed web interface like
[lime-app](https://github.com/libremesh/lime-app/) and allow the users to
request vpn access by the vpn provider.

This approach could provide people *secure connections* (to a gateway) within
an unencrypted mesh network and public IPv{4,6} provided by the gateway.

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

