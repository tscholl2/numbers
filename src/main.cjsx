React = require 'react'

start = ->
  React.render require("./header.js"), document.getElementById "header"
  React.render require("./content.js"), document.getElementById "content"
  React.render require("./footer.js"), document.getElementById "footer"

b = require "./foo/test2.js"
b()

# on site load

#try to avoid jQuery for fun!
#window.jQuery = require "jquery"
#window.$ = jQuery
#foundation = require "../node_modules/zurb-foundation-5/js/foundation/foundation.js"
#$(document).foundation()

setTimeout(start, 250)
