#!/bin/sh
# TODO: move this to own test utils package
file_a=$1; shift
file_b=$1; shift
echo "$(sha256sum $file_a | cut -d ' ' -f 1) $file_b" | sha256sum -c