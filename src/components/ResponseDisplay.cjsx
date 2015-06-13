React = require 'react'
Loading = require 'react-loading'
utils = require '../utils'
ajax = require '../ajax'
mui = require 'material-ui'
RaisedButton = mui.RaisedButton
Paper = mui.Paper
ThemeManager = new mui.Styles.ThemeManager()

SpeechBubble = React.createClass
  displayName: 'SpeechBubble'

  childContextTypes:
    muiTheme: React.PropTypes.object

  getChildContext: ->
      muiTheme: ThemeManager.getCurrentTheme()

  getDefaultProps: ->
    response: null
    status: "blank" # TODO use this to generate error object or display

  render: ->
      # TODO fix???
    <Paper rounded={true} style={borderRadius:"40px",padding:"20px"}>
      {
        if @props.response?.bytes?
          "[#{utils.base64ToByteArray(@props.response.bytes).join(', ')}]"
        else
          <Loading type='bars' />
      }
    </Paper>

# this is a controller-view
ResponseDisplay = React.createClass
    displayName: 'ResponseDisplay'

    getStateFromStore: ->
        AppStore.getCurrent()

    getInitialState: ->
        @getStateFromStore()

    componentDidMount: ->
        AppStore.addChangeListener @_onResponse

    _onResponse:  ->
        @setState @getStateFromStore()

    render: ->
        <SpeechBubble status={@state.status} response={@state.response} />


module.exports = <ResponseDisplay />
