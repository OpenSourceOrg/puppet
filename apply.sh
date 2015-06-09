#! /bin/sh

p=$(dirname $0)
puppet apply --verbose --show_diff --parser=future --hiera_config=$p/hiera.yaml --modulepath=$p/modules/ $p/manifests/site.pp "$@"
