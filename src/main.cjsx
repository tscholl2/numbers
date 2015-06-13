React = require 'react'

start = ->
  React.render require("./components/header"), document.getElementById "header"
  React.render require("./components/content"), document.getElementById "content"
  React.render require("./components/footer"), document.getElementById "footer"

# on site load
setTimeout(start, 250)
