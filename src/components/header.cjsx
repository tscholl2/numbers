React = require 'react'

Header = React.createClass
  displayName: 'Header'

  wrapperStyle:
    "textAlign": "center"

  headerStyle:
    "fontFamily": "monospace"
    "fontSize": "3em"
    "textAlign": "center"
    "fontStyle": "italic"

  render: ->
    <div style=@wrapperStyle>
      <h1 style=@headerStyle>Numbirds</h1>
      <hr />
    </div>

module.exports = <Header />
