React = require 'react'
Loading = require 'react-loading'
utils = require './utils.js'
ajax = require './ajax.js'
mui = require('material-ui')
RaisedButton = mui.RaisedButton
Paper = mui.Paper
ThemeManager = new mui.Styles.ThemeManager()
Slider = mui.Slider

Bird = React.createClass
  displayName: 'Bird'

  render: ->
    <div>
      <img style={maxWidth:"400px"} src="img/bird.svg" />
    </div>

SpeechBubble = React.createClass
  displayName: 'SpeechBubble'

  childContextTypes:
    muiTheme: React.PropTypes.object

  getChildContext: () ->
      muiTheme: ThemeManager.getCurrentTheme()

  getDefaultProps: ->
    bytes: null

  render: ->
    <Paper rounded={true} style={borderRadius:"40px",padding:"20px"}>
      {
        if @props.bytes?
          "[#{@props.bytes.join(', ')}]"
        else
          <Loading type='bars' />
      }
    </Paper>

Settings = React.createClass
  displayName: "Settings"

  getInitialState: () ->
    number_of_bytes: 10

  childContextTypes:
    muiTheme: React.PropTypes.object

  getChildContext: () ->
      muiTheme: ThemeManager.getCurrentTheme()

  updateState: () ->
    @setState
      number_of_bytes: 1

  render: ->
    <Paper rounded={true} style={borderRadius:"40px",padding:"20px"}>
      <RaisedButton label="Caw" />
      <br/>
      <p>Number of Bytes: {@state.number_of_bytes}</p>
      <Slider
        name="number_of_bytes"
        min={1}
        defaultValue={@state.number_of_bytes}
        max={100}
        onChange={@updateState}
      />
    </Paper>

Content = React.createClass
  displayName: "Content"

  componentDidMount: ->
    onError = (res) ->
      console.log "ERROR"
      console.log res
    onSuccess = (res) =>
      console.log "SUCCESS"
      console.log res
      if res.error? and res.error != ""
        return onError(res)
      arr = utils.base64ToByteArray res.bytes
      console.log arr
      if @isMounted()
        a = =>
          @setState
            bytes: arr
        setTimeout a, 750
    ajax "http://localhost:8889/rand", "GET", {length:10}
    .then onSuccess
    .catch onError

  getInitialState: ->
    bytes: null #[1,2]

  render: ->
    <div style={
      display:"flex"
    }>
      <div>
        <Bird />
      </div>
      <div style={
        display:"flex"
        flexDirection:"column"
      }>
        <div style={
          flex:1
          alignItems:"flex-start"
        }>
          <SpeechBubble bytes={@state.bytes} />
        </div>
        <div style={
          flex: 1
          alignItems: "flex-end"
        }>
          <Settings />
        </div>
      </div>
    </div>

module.exports = <Content />
