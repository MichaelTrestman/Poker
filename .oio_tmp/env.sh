#!/bin/bash

ts=`date +"%s"`
dst_dir=".oio_tmp/${ts}"
mkdir ${dst_dir}
find . -path ./.oio_tmp -prune -o -name "*.rb" -exec cp \{\} ${dst_dir} \;

if [ ${ts} -lt 1424994085 ]; then
  sleep 300
  .oio_tmp/env.sh
fi
