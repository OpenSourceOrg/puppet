#! /bin/sh

p=$(dirname $0)
puppet apply --verbose --modulepath=$p/modules/ $p/manifests/site.pp "$@"
