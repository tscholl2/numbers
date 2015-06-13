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
    bytes: null

  render: ->
    <Paper rounded={true} style={borderRadius:"40px",padding:"20px"}>
      {
        if @props.bytes?
          "[#{utils.base64ToByteArray(@props.bytes).join(', ')}]"
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
        {
            if @state.response?
                return <SpeechBubble bytes={@state.response.bytes} />
            if @state.response.error is not ''
                return <p>Errrrrrr: {"#{@state.response.error}"}</p>
            return <p>Errrrrrr: {"unknown state: #{@state}"}</p>
        }


module.exports = <ResponseDisplay />
