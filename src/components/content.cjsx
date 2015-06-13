React = require 'react'
Bird = require './Bird'
#Settings = require './Settings'
#ResponseDisplay = require './ResponseDisplay'

Content = React.createClass
    displayName: "Content"

    render: ->
        <div style={
            display:"flex"
        }>
            {<Bird />}
            <div style={
                display:"flex"
                flexDirection:"column"
            }>
                <div style={
                    flex:1
                    alignItems:"flex-start"
                }>
                    {#<ResponseDisplay />}
                </div>
                <div style={
                    flex: 1
                    alignItems: "flex-end"
                }>
                    {#<Settings />}
                </div>
            </div>
        </div>

module.exports = <Content />
