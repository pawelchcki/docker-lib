#!/bin/sh

# wrapper script to expose all of docker-lib cli through a single entrypoint script

subcommand=$1; shift

if [ $subcommand = "help" -o xx$subcommand = "xx"]; then
    printf "docker-lib runner\n\n"
    printf "usage: dl <sub-command>\n"
    printf "available subcommands: isolate-cargo, reset-fs-metadata\n"
    exit 0
fi

exec dl-$subcommand "$@"