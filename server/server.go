package main

import (
	"crypto/rand"
	"encoding/json"
	"fmt"
	"net/http"
)

type requestMessage struct {
	Length uint16 `json:"length"`
}

type responseMessage struct {
	Bytes string `json:"bytes"`
	Error string `json:"error"`
}

func reqRand(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	// check for errors and read request
	var settings requestMessage
	err := json.NewDecoder(r.Body).Decode(&settings)
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{\"error\":\"%s\"}", err.Error())))
		return
	}

	// gather output and return
	b := make([]byte, settings.Length)
	n, err := rand.Read(b)
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{\"error\":\"%s\"}", err.Error())))
		return
	}
	if n != len(b) {
		w.Write([]byte(fmt.Sprint("{\"error\":\"Unable to read enough bytes.\"}")))
		return
	}
	s := "{\"bytes\":["
	for i := 0; i < len(b); i++ {
		s += fmt.Sprintf("\"%x\"", b[i])
		if i < len(b)-1 {
			s += ","
		}
	}
	s += "]}"
	w.Write([]byte(s))
}

func main() {
	http.HandleFunc("/rand", reqRand)
	http.ListenAndServe(":8888", nil)
}
