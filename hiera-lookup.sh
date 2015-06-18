#! /bin/bash

key=$1

p=$(dirname $0)

top="${key%%:*}"
if [ "$top" = "$key" ] ; then
    hiera -c $p/hiera.yaml $key ::hostname=gpl ::settings::modulepath=$p/hieradata
else
    cur="${key#*::}"
    sel=""
    while [ "$cur" != "" ] ; do
	sub="${cur%%:*}"
	sel="$sel['$sub']"
	if [ "$cur" = "${cur#*::}" ] ; then
	    cur=
	else
	    cur="${cur#*::}"
	fi
    done
    ruby <<EOF
h=$(hiera -c $p/hiera.yaml $top ::hostname=gpl ::settings::modulepath=$p/hieradata)
print h$sel
EOF
fi
