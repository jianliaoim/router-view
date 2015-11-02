
React = require 'react'
Immutable = require 'immutable'
pathUtil = require './path'

div = React.createFactory 'div'

module.exports = React.createClass
  displayName: 'addressbar'

  propTypes:
    route: React.PropTypes.instanceOf(Immutable.Map).isRequired
    rules: React.PropTypes.instanceOf(Immutable.List).isRequired
    onPopstate: React.PropTypes.func.isRequired
    inHash: React.PropTypes.bool
    skipRendering: React.PropTypes.bool

  getDefaultProps: ->
    inHash: false
    skipRendering: false

  inHash: ->
    @props.inHash or (not window.history?)

  componentDidMount: ->
    if @inHash()
      window.addEventListener 'hashchange', @onHashchange
    else
      window.addEventListener 'popstate', @onPopstate

  conponentWillUnMount: ->
    if @inHash()
      window.removeEventListener 'hashchange', @onHashchange
    else
      window.removeEventListener 'popstate', @onPopstate

  onPopstate: (event) ->
    address = location.pathname + (location.search or '')
    info = pathUtil.getCurrentInfo @props.rules, address
    @props.onPopstate info, event

  onHashchange: ->
    if location.hash is @_cacheRenderedHash
      # changing hash in JavaScript will trigger event, by pass
      return
    address = location.hash.substr(1)
    info = pathUtil.getCurrentInfo @props.rules, address
    @props.onPopstate info

  renderInHistory: (address) ->
    routes = @props.rules
    address = pathUtil.makeAddress routes, @props.route
    if location.search?
      oldAddress = "#{location.pathname}#{location.search}"
    else
      oldAddress = location.pathname

    if oldAddress isnt address and not @props.skipRendering
      history.pushState null, null, address

  renderInHash: (address) ->
    routes = @props.rules
    address = pathUtil.makeAddress routes, @props.route

    oldAddress = location.hash.substr(1)

    if oldAddress isnt address and not @props.skipRendering
      location.hash = "##{address}"
      @_cacheRenderedHash = location.hash

  render: ->
    if @inHash()
      @renderInHash()
    else
      @renderInHistory()

    div className: 'addressbar'
