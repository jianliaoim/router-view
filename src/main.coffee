
React = require 'react'
recorder = require 'actions-recorder'

require '../styles/main.css'

schema = require './schema'
updater = require './updater'
pathUtil = require './path'
routes = require './routes'

Page = React.createFactory require './app/page'

oldAddress = "#{location.pathname}#{location.search}"
# oldAddress = location.hash.substr(1)
router = pathUtil.getCurrentInfo(routes, oldAddress)
defaultInfo =
  initial: schema.store.set 'router', router
  updater: updater

recorder.setup defaultInfo

render = (store, core) ->
  React.render Page(store: store, core: core), document.body

recorder.request render
recorder.subscribe render
