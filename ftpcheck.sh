#!/bin/bash

file="$1"
#primele verificari- daca este scris bine/ exista/ nu exista
if [ -z "$file" ]; then
	echo "EROARE! Fisier nespecificat"
	echo "Mod de scriere: nume urmat de cale: $0 cale_fisier"
	exit 1
fi

if [ ! -f "$file" ]; then
	echo "EROARE! Fisier inexistent"
	exit 1
fi 
