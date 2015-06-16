React = require 'react'
Loading = require 'react-loading'
utils = require '../utils'
mui = require 'material-ui'
RaisedButton = mui.RaisedButton
Paper = mui.Paper
ThemeManager = new mui.Styles.ThemeManager()
AppStore = require '../stores/AppStore'

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
        console.log "rendering bubble: "
        console.log @props
        switch @props.status
          when "recieved"
            res = if @props.response? then @props.response else {}
            if res.error? and res.error is not ""
              "Err: #{res.error}"
            else
              if res.bytes?
                "[#{utils.base64ToByteArray(res.bytes).join(', ')}]"
          when "sent"
            <Loading type='bars' />
          when "blank"
            "Hello!"
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

    _onResponse: ->
        console.log "ResponseDisplay: _onResponse"
        @setState @getStateFromStore()

    render: ->
        <SpeechBubble status={@state.status} response={@state.response} />


module.exports = ResponseDisplay
