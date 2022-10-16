package main

import (
	"flag"
	"jwtsign/jwt"
	"fmt"
)

var (
	flagKey    = flag.String("key", "", "path to the .p8 key file")
	flagHeader = flag.String("header", "", "json header content")
	flagPayload = flag.String("payload", "", "json payload content")
)

func main() {
	flag.Parse()
	
	
	jwToken, err := jwt.Token(*flagHeader, *flagPayload, *flagKey)
	if(err != nil) {
		fmt.Println("Error signing the token")
	} else {
		fmt.Println(jwToken)
	}
}
