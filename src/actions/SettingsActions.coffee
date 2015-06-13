
AppDispatcher = require '../dispatcher/AppDispatcher'
AppConstants = require '../constants/AppConstants'

module.exports =

    sendRequest: (settings) ->
        ajax "http://localhost:8889/rand", "GET", @state
        .then @_onSuccess
        .catch @_onError
        # not sure if this is ok...
        AppDispatcher.dispatch
            actionType: AppConstants.REQUEST_SENT

    _onError: (res) ->
        AppDispatcher.dispatch
            actionType: AppConstants.RESPONSE_RECIEVED
        console.log "ERROR"
        console.log res

    _onSuccess: (res) ->
        AppDispatcher.dispatch
            actionType: AppConstants.RESPONSE_RECIEVED
        console.log "SUCCESS"
        console.log res
