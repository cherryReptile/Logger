package main

import (
	"github.com/Logger/app/internal/app"
)

func main() {
	app := app.NewApp()
	app.Run("80")
}
