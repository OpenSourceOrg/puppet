#! /bin/sh

p=$(dirname $0)
puppet apply --verbose --show_diff --parser=future --modulepath=$p/modules/ $p/manifests/site.pp "$@"
