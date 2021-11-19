package main

import (
	"testing"

	"github.com/kami-zh/go-capturer"
	"github.com/stretchr/testify/assert"
)

func TestRun(t *testing.T) {
	out := capturer.CaptureStdout(func() {
		main()
	})

	assert.Contains(t, out, "hello world!")
}
