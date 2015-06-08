React = require 'react'
HeaderComponent = React.createClass
  render: ->
    <div className="row">
      <div className="small-12 columns text-center">
        {<h1>Numbirds</h1>}
      </div>
      <hr />
    </div>

module.exports = HeaderComponent
