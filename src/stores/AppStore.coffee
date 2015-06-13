
AppDispatcher = require '../dispatcher/AppDispatcher'
EventEmitter = require('events').EventEmitter
AppConstants = require '../constants/AppConstants'
assign = require 'object-assign'

CHANGE_EVENT = 'change'

_data = {}
_ids = []

create = (response) ->
    id = (+new Date() + Math.floor(Math.random() * 999999)).toString 36
    _todos[id] =
        id: id
        response: response
    _ids.push id

AppStore = assign {}, EventEmitter.prototype

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

    switch action.actionType
        when AppConstants.RESPONSE_RECIEVED
            if action.reponse?
                create action.response
                AppStore.emitChange()

        when AppConstants.REQUEST_SENT
            AppStore.emitChange()

module.exports = AppStore;
