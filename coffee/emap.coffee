if require
    Dict = require 'jsdictionary'
else
    Dict = this.JSDictionary


class EventMap


    ###
        00000000  000   000  00000000  000   000  000000000  00     00   0000000   00000000
        000       000   000  000       0000  000     000     000   000  000   000  000   000
        0000000    000 000   0000000   000 0 000     000     000000000  000000000  00000000
        000          000     000       000  0000     000     000 0 000  000   000  000
        00000000      0      00000000  000   000     000     000   000  000   000  000
    ###
    constructor: () ->
        @dispatcherMap = new Dict()  




    ###
        00     00   0000000   00000000
        000   000  000   000  000   000
        000000000  000000000  00000000
        000 0 000  000   000  000
        000   000  000   000  000
    ###
    map: (dispatcher, type, handler, owner, useCapture = false) ->
        listenerMap = @dispatcherMap.get(dispatcher) ? @dispatcherMap.map(dispatcher, {})
        listeners   = listenerMap[type] ? listenerMap[type] = []

        for info in listeners
            return null if info.h == handler and info.o == owner and info.u == useCapture

        if dispatcher.addEventListener
            if owner
                callback = (args...) -> handler.apply(owner, args); null
                dispatcher.addEventListener(type, callback, useCapture)
            else
                dispatcher.addEventListener(type, handler, useCapture)

        else if dispatcher.on
            if owner
                callback = (args...) -> handler.apply(owner, args); null
                dispatcher.on(type, callback, useCapture)
            else
                dispatcher.on(type, handler, useCapture)

        else if dispatcher.add
            dispatcher.add(type, handler, owner)

        listeners.push(d:dispatcher, o:owner, h:handler, u:useCapture, c:callback)
        null




    ###
        000   000  000   000  00     00   0000000   00000000
        000   000  0000  000  000   000  000   000  000   000
        000   000  000 0 000  000000000  000000000  00000000
        000   000  000  0000  000 0 000  000   000  000
         0000000   000   000  000   000  000   000  000
    ###
    unmap: (dispatcher, type, handler, owner, useCapture = false) ->
        listenerMap = @dispatcherMap.get(dispatcher)
        return null if not listenerMap
        listeners = listenerMap[type]
        return null if not listeners

        i = listeners.length
        while --i >= 0
            info = listeners[i]
            if info.h == handler and info.o == owner and info.u == useCapture
                listeners.splice(i, 1)

                if dispatcher.removeEventListener
                    if owner
                        dispatcher.removeEventListener(type, info.c, useCapture)
                    else
                        dispatcher.removeEventListener(type, handler, useCapture)

                else if dispatcher.off
                    if owner
                        dispatcher.off(type, info.c, useCapture)
                    else
                        dispatcher.off(type, handler, useCapture)

                else if dispatcher.remove
                    dispatcher.remove(type, handler, owner)

        delete listenerMap[type] if not listeners.length
        @dispatcherMap.unmap(dispatcher) if not Dict.hasKeys(listenerMap)
        null




    ###
         0000000   000      000
        000   000  000      000
        000000000  000      000
        000   000  000      000
        000   000  0000000  0000000
    ###
    all: ->
        @dispatcherMap.forEach((dispatcher, listenerMap) =>
            for type, listeners of listenerMap
                while info = listeners.shift()
                    if dispatcher.removeEventListener
                        if info.o
                            dispatcher.removeEventListener(type, info.c, info.u)
                        else
                            dispatcher.removeEventListener(type, info.h, info.u)

                    else if dispatcher.off
                        if info.o
                            dispatcher.off(type, info.c, info.u)
                        else
                            dispatcher.off(type, info.h, info.u)

                    else if dispatcher.remove
                        dispatcher.remove(type, info.h, info.o)
            @dispatcherMap.unmap(dispatcher))
        null




###
    00000000  000   000  00000000    0000000   00000000   000000000   0000000
    000        000 000   000   000  000   000  000   000     000     000
    0000000     00000    00000000   000   000  0000000       000     0000000
    000        000 000   000        000   000  000   000     000          000
    00000000  000   000  000         0000000   000   000     000     0000000
###


if(module)
    ### node export ###
    module.exports = EventMap
else
    ### browser export ###
    this.EventMap = EventMap
