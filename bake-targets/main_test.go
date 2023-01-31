package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParsingHCLGroups(t *testing.T) {
	hcl := `
	target "target_a" {}
	group "group_a" {
		targets = ["target_a"]
	}
	group "group_b" {
		targets = []
	}
	`
	t.Run("group_a is found and points to a target", func(t *testing.T) {
		assert := assert.New(t)
		res, err := listGroupTargets([]byte(hcl), "file.hcl", "group_a")
		assert.NoError(err)
		assert.NotEmpty(res)

		assert.Equal("target_a", res[0])
	})

	t.Run("group_b found with 0 targets", func(t *testing.T) {
		assert := assert.New(t)
		res, err := listGroupTargets([]byte(hcl), "file.hcl", "group_b")
		assert.NoError(err)
		assert.Empty(res)
	})

	t.Run("group_c not found", func(t *testing.T) {
		assert := assert.New(t)
		res, err := listGroupTargets([]byte(hcl), "file.hcl", "group_c")
		assert.Error(err)
		assert.Empty(res)
	})
}
