package main

import (
	"airbytetest/apisource"
	"log"
	"os"
	"github.com/bitstrapped/airbyte"
)

func main() {
	// Add debugging
	log.Printf("Starting application...")
	log.Printf("Command line args: %v", os.Args)
	log.Printf("Working directory: %s", func() string { pwd, _ := os.Getwd(); return pwd }())
	
	liveSRC := apisource.NewAPISource("https://bitstrapped.com")
	log.Printf("Created HTTP source")
	
	runner := airbyte.NewSourceRunner(liveSRC, os.Stdout)
	log.Printf("Created source runner")
	
	log.Printf("About to call Start()...")
	if err := runner.Start(); err != nil {
		log.Printf("Error from Start(): %v", err)
		log.Fatal(err)
	}
	log.Printf("Start() completed successfully")
}
