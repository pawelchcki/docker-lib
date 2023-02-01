#!/bin/sh
## group Cargo files and required stubs
output=$1; shift
if [ "xx$output" -eq xx ]; then
    output=/output/cargo
fi
mkdir -p $output

cp Cargo.lock $output
find . -name "Cargo.toml" | xargs -n 1 sh -c 'export OUT=$output/$1; mkdir -p $(dirname $OUT); cp $1 $OUT; echo $OUT' copy_cargo
find . -name "Cargo.toml" | sed -e s#Cargo.toml#src/lib.rs#g | xargs -n 1 sh -c 'export OUT=$output/$1; mkdir -p $(dirname $OUT); touch $OUT; echo $OUT' create_lib_stubs
find . -wholename "*/benches/*.rs" -o -wholename "*/src/bin/*.rs" -o -wholename "*/examples/*.rs" | xargs -n 1 sh -c 'export OUT=$output/$1; mkdir -p $(dirname $OUT); touch $OUT; echo $OUT' create_required_stubs
find $output | xargs dl-reset-fs-metadata -v
