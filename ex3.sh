#!/bin/bash
cat /etc/hosts | while read -r ip nume restul; do
	if [[ -z "$ip" || "$ip" == "#"* || "$nume" == "localhost" ]] ; then
		continue
	fi
	ip_bun=$(nslookup "$nume" | grep "Address:" | tail -n 1 | awk '{print $2}' | xargs)
	if [[ -n "$ip_bun" && "$ip" != "ip_bun" ]]; then
		echo "Bogus IP for $nume in /etc/hosts!"
		echo "In fisier: $ip"
		echo "In DNS: $ip_bun"
	fi
done
