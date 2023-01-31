package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"time"
)

var defaultTime = time.Date(1970, time.Month(1), 1, 0, 0, 0, 1, time.UTC)

func main() {
	flagSet := flag.CommandLine
	flagSet.Usage = func() {
		fmt.Fprintf(flagSet.Output(), "Usage: reset-fs-metadata PATHS...\n")
		fmt.Fprintf(flagSet.Output(), "  PATHS... files, directories or glob patterns\n")

		flagSet.PrintDefaults()
	}
	verbose := flagSet.Bool("v", false, "enable verbose output")
	flagSet.Parse(os.Args[1:])

	if flagSet.NArg() == 0 {
		flagSet.Usage()
		os.Exit(0)
	}

	for _, arg := range flag.Args() {
		paths, err := filepath.Glob(arg)
		if err != nil {
			panic(err)
		}
		for _, path := range paths {
			if *verbose {
				println(path)
			}
			err := os.Chtimes(path, defaultTime, defaultTime)
			if err != nil {
				panic(err)
			}
		}
	}
}
