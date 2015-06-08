React = require 'react'

NeatComponent = React.createClass
  render: ->
    <div className="neat-component">
      {<h1>A Component is I</h1> if @props.showTitle}
      <hr />
      {<p key={n}>This line has been printed {n} times</p> for n in [1..5]}
    </div>

HeaderComponent = React.createClass
  render: ->
    <div className="row">
      <div className="small-12 columns text-center">
        {<h1>Numbirds</h1>}
      </div>
      <hr />
    </div>

Content = React.createClass

start = ->
  #header = require "./header.js"
  React.render <HeaderComponent />, document.getElementById "content"
  #React.render <NeatComponent />, document.getElementById "content"

a = require "./test.js"
a()

b = require "./foo/test2.js"
b()

# on site load

#try to avoid jQuery for fun!
#window.jQuery = require "jquery"
#window.$ = jQuery
#foundation = require "../node_modules/zurb-foundation-5/js/foundation/foundation.js"
#$(document).foundation()

setTimeout(start, 250)
