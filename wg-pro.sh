#!/bin/sh

WIREGUARD_IP="./wireguard_ip"
WIREGUARD_CLIENTS="./wireguard_clients"
WIREGUARD_PRIVATE_KEY="./private_key"

rm -rf ./public
mkdir -p ./public

uci() {
	echo "uci $@"
}

uci set network.wg0="interface"
uci set network.wg0.proto="wireguard"
uci set network.wg0.private_key="$(cat $WIREGUARD_PRIVATE_KEY)"
uci set network.wg0.listen_port="46761"
uci set network.wg0.addresses="$(cat $WIREGUARD_IP)"

if [ -e $WIREGUARD_CLIENTS ] && [ -f wireguard_ips ]; then
	uci delete network wireguard_wg0
	while read p; do
		ip="$(echo $p | awk '{ print $1 }')"
		pubkey="$(echo $p | awk '{ print $2 }')"
		if [ -n "$pubkey" ]; then
			pubkey_sha256="$(echo $pubkey | sha256sum)"
			echo $ip > ./public/${pubkey_sha256%% *}
		uci add network wireguard_wg0
		uci set network.@wireguard_wg0[-1].public_key="$pubkey"
		uci add_list network.@wireguard_wg0[-1].allowed_ips="$ip/32"
		uci set network.@wireguard_wg0[-1].route_allowed_ips="1"
		uci set network.@wireguard_wg0[-1].endpoint_port="51820"
		fi
	done < $WIREGUARD_CLIENTS
else
	./ip-gen.sh "$(cat ip)" | tail -n +2 > $WIREGUARD_CLIENTS
fi

uci commit network
