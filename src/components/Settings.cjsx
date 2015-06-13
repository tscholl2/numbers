React = require 'react'
ajax = require '../ajax'
mui = require 'material-ui'
RaisedButton = mui.RaisedButton
Paper = mui.Paper
ThemeManager = new mui.Styles.ThemeManager()
Slider = mui.Slider
Bird = require './Bird'
AppActions = require '../actions/AppActions'

Settings = React.createClass
  displayName: "Settings"

  getInitialState: ->
    length: 10

  childContextTypes:
    muiTheme: React.PropTypes.object

  getChildContext: ->
      muiTheme: ThemeManager.getCurrentTheme()

  updateState: ->
    @setState
      number_of_bytes: 1

  onClick: ->
      AppActions.sendRequest @state

  render: ->
    <Paper rounded={true} style={borderRadius:"40px",padding:"20px"}>
      <RaisedButton label="Caw" />
      <br/>
      <p>Number of Bytes: {@state.length}</p>
      <Slider
        name="number_of_bytes"
        min={1}
        defaultValue={@state.length}
        max={100}
        onChange={@updateState}
      />
    </Paper>

module.exports = <Settings />
