React = require 'react'

Header = require("./components/header")
Content = require("./components/content")
Footer = require("./components/footer")

start = ->
  React.render <Header />, document.getElementById "header"
  React.render <Content />, document.getElementById "content"
  React.render <Footer />, document.getElementById "footer"

# on site load
setTimeout(start, 250)
