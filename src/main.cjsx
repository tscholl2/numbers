React = require 'react'

start = ->
  React.render require("./header.js"), document.getElementById "header"
  React.render require("./content.js"), document.getElementById "content"
  React.render require("./footer.js"), document.getElementById "footer"

b = require "./foo/test2.js"
b()

# on site load
setTimeout(start, 250)
