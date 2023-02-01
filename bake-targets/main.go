package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/docker/buildx/bake"
)

func listGroupTargets(dt []byte, fn string, groupName string) ([]string, error) {
	cfg, err := bake.ParseFile(dt, fn)

	if err != nil {
		return []string{}, err
	}

	for _, group := range cfg.Groups {
		if group.Name == groupName {
			return group.Targets, nil
		}
	}

	return []string{}, fmt.Errorf("group %s not found", groupName)
}

func main() {
	flagSet := flag.CommandLine
	flagSet.Usage = func() {
		fmt.Fprintf(flagSet.Output(), "Usage: bake-targets PATH\n")
		fmt.Fprintf(flagSet.Output(), "  PATH to docker-bake.hcl file\n")

		flagSet.PrintDefaults()
	}
	groupName := flagSet.String("g", "default", "bake group to list targets for")
	flagSet.Parse(os.Args[1:])

	if flagSet.NArg() == 0 {
		flagSet.Usage()
		os.Exit(0)
	}

	filePath := flagSet.Arg(0)

	contents, err := ioutil.ReadFile(filePath)
	if err != nil {
		panic(err)
	}

	targets, err := listGroupTargets(contents, filePath, *groupName)
	if err != nil {
		panic(err)
	}

	// fmt.Println(strings.Join(targets, "\n"))
	output, err := json.Marshal(targets)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(output))
}
