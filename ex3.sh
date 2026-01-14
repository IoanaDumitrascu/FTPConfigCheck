#!/bin/bash

verif_ip(){

	local ip_1=$1
	local nume_host=$2

	local ip_2=$(nslookup "$nume_host" | grep "Adress:" | tail -n 1 | awk '{print $2}')
	if [[ -n "$ip_2" && "ip_1" != "ip_2" ]]; then
		echo "Bogus IP pt $nume_host"
	fi
}

cat /etc/hosts | while read -r ip nume restul; do
	if [[ -z "$ip" || "$ip" == "#"* || "$nume" == "localhost" ]] && continue
	
	verif_ip "$ip" "$nume"
done
