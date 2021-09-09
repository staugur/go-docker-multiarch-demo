package main

import (
	"fmt"
	"net/http"
	"runtime"
)

func main() {
	msg := fmt.Sprintf(
		"os/arch/version: %s/%s/%s\n",
		runtime.GOOS,
		runtime.GOARCH,
		runtime.Version(),
	)
	fmt.Println(msg)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, msg)
	})
	http.ListenAndServe(":9999", nil)
}
