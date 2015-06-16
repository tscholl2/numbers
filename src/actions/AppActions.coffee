
AppDispatcher = require '../dispatcher/AppDispatcher'
AppConstants = require '../constants/AppConstants'
ajax = require '../ajax'

module.exports =

    sendRequest: (settings) ->
      console.log "actions: calling ajax"
      ajax "http://localhost:8889/rand", "GET", settings
      .then @_onSuccess
      .catch @_onError
      # not sure if this is ok...
      AppDispatcher.dispatch
          actionType: AppConstants.REQUEST_SENT

    _onError: (res) ->
      console.log "actions: ERROR"
      console.log res
      f = -> AppDispatcher.dispatch
          actionType: AppConstants.RESPONSE_RECIEVED
          response: res
      setTimeout f, 1000

    _onSuccess: (res) ->
      console.log "actions: SUCCESS"
      console.log res
      f = -> AppDispatcher.dispatch
          actionType: AppConstants.RESPONSE_RECIEVED
          response: res
      setTimeout f, 1000
