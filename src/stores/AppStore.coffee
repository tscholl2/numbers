
AppDispatcher = require '../dispatcher/AppDispatcher'
EventEmitter = require('events').EventEmitter
AppConstants = require '../constants/AppConstants'
assign = require 'object-assign'

CHANGE_EVENT = 'change'

_data = {}
_ids = []

create = (response) ->
    id = (+new Date() + Math.floor(Math.random() * 999999)).toString 36
    if response?
        _data[id] =
            id: id
            status: "recieved"
            response: response
    else
        _data[id] =
            id: id
            status: "sent"
            response: null
    _ids.push id

AppStore = assign {}, EventEmitter.prototype,

    emitChange: ->
        @emit CHANGE_EVENT

    addChangeListener: (callback) ->
        @on CHANGE_EVENT, callback

    removeChangeListener: (callback) ->
        @removeListener CHANGE_EVENT, callback

    getCurrent: ->
        if _ids.length == 0
            return {}
        else
            return _data[_ids[_ids.length-1]]

# Register callback to handle all updates
AppDispatcher.register (action) ->
  console.log "store: regiserting..."
  switch action.actionType
      when AppConstants.RESPONSE_RECIEVED
        console.log "store: response recieved"
        console.log "store: action = "
        console.log action
        if action.response?
          console.log "store: emitting response change"
          create action.response
          AppStore.emitChange()

      when AppConstants.REQUEST_SENT
        create null
        AppStore.emitChange()

module.exports = AppStore;
