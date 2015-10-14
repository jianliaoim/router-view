
router = require './router'

module.exports = (store, actionType, actionData) ->
  switch actionType
    when 'router/go'
      router.go store, actionData
    else
      console.warn ":Unknown action type: #{actionType}"
      store
