package main

import (
    "fmt"
    "time"
)

func main() {
    for true {
	fmt.Println(time.Now().Format("2006-01-02 15:04:05"), ": it will sleep 10s ...")
        time.Sleep(10 * time.Second)
    }

    return
}
