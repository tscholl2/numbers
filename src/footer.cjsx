React = require 'react'

Footer = React.createClass
  displayName: 'Footer'

  wrapperStyle:
    "display": "block"
    "textAlign": "center"

  footerStyle:
    "color": "lightslategrey"
    "display": "inline-block"
    "padding": "5px"
    "opacity": "0.6"

  render: ->
    <div style=@wrapperStyle>
      <hr />
      <p style=@footerStyle>Footer stuff goes here.</p>
    </div>
  shouldComponentUpdate: ->
      return false

module.exports = <Footer />
