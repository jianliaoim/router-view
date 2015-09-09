
routerController = require './controllers/router'

module.exports = (store, actionType, actionData) ->
  switch actionType
    when 'router/go'
      routerController.go store, actionData
    else
      console.warn ":Unknown action type: #{actionType}"
      store
