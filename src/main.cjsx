React = require 'react'

Header = require "./header.js"
Footer = require "./footer.js"
Content = require "./content.js"

start = ->
  React.render Header, document.getElementById "header"
  React.render Content, document.getElementById "content"
  React.render Footer, document.getElementById "footer"

b = require "./foo/test2.js"
b()

# on site load

#try to avoid jQuery for fun!
#window.jQuery = require "jquery"
#window.$ = jQuery
#foundation = require "../node_modules/zurb-foundation-5/js/foundation/foundation.js"
#$(document).foundation()

setTimeout(start, 250)
