#!/bin/bash
cmd="docker run --rm -v $(pwd)/src:/srv/gitbook -v $(pwd)/html:/srv/html argonhiisi/gitbook:bdd gitbook build . /srv/html"
echo $cmd
eval $cmd

