React = require 'react'
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

  updateLength: (e,value)->
    @setState
      length: Math.floor value

  onClick: ->
      AppActions.sendRequest @state

  render: ->
    <Paper rounded={true} style={borderRadius:"40px",padding:"20px"}>
      <RaisedButton label="Caw" onClick={@onClick}   />
      <br/>
      <p>Number of Bytes: {@state.length}</p>
      <Slider
        name="number_of_bytes"
        min={1}
        defaultValue={@state.length}
        max={100}
        onChange={@updateLength}
      />
    </Paper>

module.exports = Settings
