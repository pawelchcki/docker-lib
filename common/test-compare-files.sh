#!/bin/sh
# TODO: move this to own test utils package
file_a=$1; shift
file_b=$1; shift
sha256sum $file_a | sed -e "s/$file_a/$file_b/" | sha256sum -c