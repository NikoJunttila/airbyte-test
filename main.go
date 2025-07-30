package main

import (
	"fmt"
	"log"
	"os"

	"github.com/bitstrapped/airbyte"
)


func main(){
	fmt.Println("hellope")
	if err := airbyte.NewSourceRunner(nil, os.Stdout).Start(); err != nil{
		log.Fatal(err)
	}
	
}
