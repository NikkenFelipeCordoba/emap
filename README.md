# emap  
Manages event listeners.

Creates and manages closures for your event handling and makes it easy to remove them.   
Use the EventMap, if you repeatedly have to remove listeners owned by an instance or
if you want to remove all registered listeners at once.

Works with:

- addEventListener/removeEventListener (browser)
- on/off (node)
- add/remove (my own)

### Usage  

```coffee-script
    
    # node
    EventMap = require 'emap'
    
    # browser
    # as global EventMap
    
    eventMap = new EventMap()
    
```
### Example  

```coffee-script
    
    # node
    EventEmiter = require 'events'
    emiter      = new EventEmiter()
     
    # browser 
    anchor = document.createElement 'a'
    
    # handler function
    myHandler = (type, args...) ->
        console.log "myHandler handles '#{type}' with args, ", args
    
    # object with handler
    myObject = 
        handler: (type, args...) ->
            console.log "#{this} handles '#{type}' with args, ", args
    
    # map dispatcher, type, handler, owner = null, useCapture = false
    eventMap.map emiter, 'ready', myHandler
    eventMap.map emiter, 'ready', myObject.handler, myObject
    eventMap.map anchor, 'click', myHandler
    eventMap.map anchor, 'click', myObject.handler, myObject, true
    
    # unmap dispatcher, type, handler, owner = null, useCapture = false
    eventMap.unmap emiter, 'ready', myHandler
    eventMap.unmap emiter, 'ready', myObject.handler, myObject
    eventMap.unmap emiter, 'ready', myHandler
    eventMap.unmap emiter, 'ready', myObject.handler, myObject
    
    
    # all
    eventMap.all()
    
```