package main

import (
	"crypto/rand"
	"fmt"
	"net/http"
	"strconv"

	"github.com/tscholl2/pisearch/digits"
)

func requestRandom(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	// check for errors and read request
	err := r.ParseForm()
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{err:%s}", err.Error())))
		return
	}
	n, err := strconv.Atoi(r.FormValue("n"))
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{err:\"%s\"}", err.Error())))
		return
	}
	if n < 0 || n > 100 {
		w.Write([]byte("{err:\"Invalid request.\"}"))
		return
	}
	// return request
	b := make([]byte, n)
	_, err = rand.Read(b)
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{err:\"%s\"}", err.Error())))
		return
	}
	s := "{bytes:["
	for i := 0; i < n; i++ {
		s += fmt.Sprintf("%x", b[i])
		if i < len(b)-1 {
			s += ","
		}
	}
	s += "]}"
	w.Write([]byte(s))
}

func requestPi(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	// check for errors and read request
	err := r.ParseForm()
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{err:%s}", err.Error())))
		return
	}
	start, err := strconv.Atoi(r.FormValue("start"))
	if err != nil {
		w.Write([]byte(fmt.Sprintf("err:%s", err.Error())))
		return
	}
	length, err := strconv.Atoi(r.FormValue("length"))
	if err != nil {
		w.Write([]byte(fmt.Sprintf("{err:\"%s\"}", err.Error())))
		return
	}
	if start < 0 || start > 10000000 {
		w.Write([]byte("{err:\"Invalid starting place.\"}"))
		return
	}
	if length <= 0 || length > 100 {
		w.Write([]byte("{err:\"Invalid length.\"}"))
		return
	}
	// reply
	chars := digits.Get(start, length)
	w.Write([]byte(fmt.Sprintf("{digits:%s}", string(*chars))))
}

func main() {
	http.HandleFunc("/pi", requestPi)
	http.HandleFunc("/rand", requestRandom)
	http.ListenAndServe(":8888", nil)
}
