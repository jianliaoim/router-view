
React = require 'react'
recorder = require 'actions-recorder'

require 'origami-ui'
require 'actions-recorder/style/actions-recorder.css'
require '../styles/main.css'

schema = require './schema'
updater = require './updater'
utilPath = require './util/path'
routes = require './routes'

Page = React.createFactory require './app/page'

oldAddress = "#{location.pathname}#{location.search}"
# oldAddress = location.hash.substr(1)
router = utilPath.getCurrentInfo(utilPath.expandRoutes(routes), oldAddress)
defaultInfo =
  initial: schema.store.set 'router', router
  updater: updater

recorder.setup defaultInfo

render = (store, core) ->
  React.render Page(store: store, core: core), document.body

recorder.request render
recorder.subscribe render
