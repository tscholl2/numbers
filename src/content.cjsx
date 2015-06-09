React = require 'react'
Loading = require 'react-loading'

base64ToByteArray = (s) ->
  b = []
  i = 0
  d = atob(s)
  while not isNaN d.charCodeAt i
    b.push(d.charCodeAt(i))
    i++
  return b

encodeURIObject = (obj) ->
  s = ""
  for k,v of obj
    s += "\&#{encodeURIComponent(k)}=#{encodeURIComponent(v)}"
  return s

get = (url,type="GET",data=null) ->
  # Return a new promise.
  new Promise (resolve, reject) ->
    # Do the usual XHR stuff
    req = new XMLHttpRequest()
    if data? and type is "GET"
      url += "?#{encodeURIObject(data)}"
    req.open type, url

    req.onload = () ->
      # This is called even on 404 etc
      # so check the status
      if req.status == 200
        # Resolve the promise with the response text
        console.log req.response
        resolve JSON.parse(req.response)
      else
        # Otherwise reject with the status text
        # which will hopefully be a meaningful error
        reject Error req.statusText

    # Handle network errors
    req.onerror = () ->
      reject Error "Network Error"

    # Make the request
    if type is "POST" and data?
      req.send encodeURIObject data
    else
      req.send()


Bird = React.createClass
  displayName: 'Bird'

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
  displayName: 'SpeechBubble'

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
    "border": "2px solid black"
    "wordWrap": "break-word"

  getDefaultProps: ->
    bytes: null

  render: ->
    <div style=@wrapperStyle>
        <div>
          <div style=@bubbleStyle>
            {if @props.bytes? then "[#{@props.bytes}]" else <Loading type='bars' />}
          </div>
        </div>
    </div>

Settings = React.createClass
  displayName: "Settings"
  #TODO write this

  render: ->
    #TODO write this

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
      arr = base64ToByteArray res.bytes
      console.log arr
      if @isMounted()
        a = =>
          @setState
            bytes: arr
        setTimeout a, 750
    get "http://localhost:8889/rand", "GET", {length:10}
    .then onSuccess
    .catch onError

  getInitialState: ->
    bytes: null #[1,2]

  render: ->
    <div style={display:"flex"}>
      <Bird />
      <SpeechBubble bytes={@state.bytes} />
    </div>

module.exports = <Content />
