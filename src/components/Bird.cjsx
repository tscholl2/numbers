React = require 'react'

Bird = React.createClass
    displayName: 'Bird'

    render: ->
        <div>
            <img style={maxWidth:"400px"} src={"img/bird.svg"} />
        </div>

module.exports = <Bird />
