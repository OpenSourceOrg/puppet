#! /bin/bash

# set -x

key="$1"

p=$(dirname $0)
h=$(facter hostname)

foo () {
    k="$1"
    s="$2"

    ruby <<EOF
h=\`hiera -c $p/hiera.yaml $k ::hostname=$h ::settings::modulepath=$p/hieradata\`
print h$s
EOF
}

cv=$(foo $key)
sub=""

while [ "$cv" == nil ] && [ "$key" != "" ] ; do
    if [ "$key" = "${key%%:*}" ] ; then
	key=""
    else
        sub="['${key##*::}']$sub"
        key="${key%::*}"
    fi
    # key="$nk"
    cv="$(foo $key)"
done

case "$cv" in
	\{*)
		;;
	*)
		cv="%Q|$cv|"
		;;
esac

#echo FOUND "$cv"
# echo SUB "$sub"
echo

ruby <<EOF
h=$cv
print h$sub
EOF

exit
top="${key%%:*}"
if [ "$top" = "$key" ] ; then
    hiera -c $p/hiera.yaml $key ::hostname=$h ::settings::modulepath=$p/hieradata
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
h=$(hiera -c $p/hiera.yaml $top ::hostname=$h ::settings::modulepath=$p/hieradata)
print h$sel
EOF
fi
