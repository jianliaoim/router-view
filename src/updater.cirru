
var
  routerController $ require :./controllers/router

= module.exports $ \ (store actionType actionData)
  case actionType
    :router/go
      routerController.go store actionData
    else
      console.warn $ + ":Unknown action type: " actionType
      , store
