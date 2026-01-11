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
#am verificat ca numele fisierului este scris si ca acesta exista
#acum incepem analiza fisierului
echo "analiza fisier: $file"

#verificam permisiunile si proprietarul
full_ls=$(ls -ld "$file")
perm="${full_ls:0:10}"
owner=$(ls -ld "$file" | awk '{print $3}')

echo "permisiuni: $perm"
echo "proprietar: $owner"

#verificam permisiunile pt 'others'- ultimlele 3 caractere
others_perm="${perm:8:3}"
#daca au drept de scriere, fisierul nu mai este sigur deoarece oricine poate aduce orice modificare
if echo "$others_perm" | grep -q "w"; then
	echo "ATENTIE! permisiuni de scriere nesigure"
else
	echo "OK! permisiuni de scriere sigure"
fi

