package main

import (
	"fmt"

	"github.com/KEINOS/go-utiles/util"
)

func main() {
	util.ExitOnErr(Run())
}

func Run() error {
	_, err := fmt.Println("hello world!")

	return err
}
