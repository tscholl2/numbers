React = require 'react'

Bird = React.createClass

  birdStyle:
    "flex": 1
    "alignItems": "flex-end"
    "textAlign": "right"
    "flexGrow": 2

  render: ->
    <div style=@birdStyle >
      <img src="img/bird.svg" />
    </div>

SpeechBubble = React.createClass

  wrapperStyle:
    "flex": 1
    "alignItems": "flex-start"
    "textAlign": "left"

  bubbleStyle:
    "backgroundColor": "white"
    "margin": "2px"
    "padding": "20px"
    "borderRadius": "50px"
    "textAlign": "left"
    "display": "inline-block"
    "border": "2x solid black"

  render: ->
    <div style=@wrapperStyle>
        <div>
          <p style=@bubbleStyle>{Math.random()}</p>
        </div>
    </div>

Content = React.createClass
  render: ->
    <div style={display:"flex"}>
      <Bird />
      <SpeechBubble />
    </div>

module.exports = <Content />
