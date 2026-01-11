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

#verificam directivele
#definim regulile
#prima-persoanele anonime(fara nume utilizator,parola) nu au acces
#a doua-persoanele anonime nu pot incarca fisiere
#a treia-izolare-utilizatorii nu pot iesi din folderul lor sa intre prin fisierele sistemului
reguli="anonymous_enable:NO anon_upload_enable:NO chroot_local_user:YES"

for regula in $reguli; do
	#separam regula in nume directiva si valoarea buna
	directiva=$(echo $regula | cut -d: -f1)
	val_ok=$(echo $regula| cut -d: -f2) 
	#incepem sa cautam liniile in fisier care incep cu numele directivei, nu luam si comentariile posibile
	linii=$(grep "^$directiva=" "$file")
	#verificam daca e setata sau nu
	if [ -z "$linii" ]; then
		echo " $directiva nu este setata"
	else
		#incepem sa numaram liniile care covin pt a stii daca exista sau nu duplicate
		nr_linii=$(echo "$linii" | grep -c "^")
		if [ "$nr_linii" -gt 1 ]; then
			echo "Duplicat! $directiva apare de $nr_linii ori"
			echo "liniile respective sunt:"
			echo "$linii"
		fi
