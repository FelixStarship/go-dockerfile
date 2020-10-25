package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func main()  {
	fmt.Println("Server Read")
	route:=gin.Default()
	route.GET("/", func(context *gin.Context) {
		context.String(200,"hello world!")
	})
	route.GET("/github", func(context *gin.Context) {
		_,err:=http.Get("https://api.github.com/")
		if err!=nil {
			context.String(500,err.Error())
		}
		context.String(200,"success~")
	})
	if err:=route.Run(":9999");err!=nil {
		panic(err.Error())
	}
}