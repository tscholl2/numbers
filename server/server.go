package main

import (
	"crypto/rand"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

type requestMessage struct {
	Length uint16 `json:"length"`
}

type responseMessage struct {
	Bytes []byte `json:"bytes"`
	Error string `json:"error"`
}

func reqRand(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	// check for errors and read request
	var settings requestMessage
	var msg responseMessage
	r.ParseForm()
	l, err := strconv.ParseUint(r.FormValue("length"), 10, 16)
	if err != nil {
		msg.Error = err.Error()
	}
	settings.Length = uint16(l)

	// gather output and return

	b := make([]byte, settings.Length)
	msg.Bytes = b
	n, err := rand.Read(msg.Bytes)
	if err != nil {
		msg.Error = err.Error()
	}
	if n != len(b) {
		msg.Error = "Unable to read enough bytes."
	}

	m, _ := json.Marshal(&msg)
	w.Write(m)

	fmt.Println(string(m))

	return
}

func main() {
	http.HandleFunc("/rand", reqRand)
	http.ListenAndServe(":8889", nil)
}
