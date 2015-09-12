
React = require 'react'
Immutable = require 'immutable'
utilPath = require './util/path'
prelude = require './util/prelude'

div = React.createFactory 'div'

module.exports = React.createClass
  displayName: 'addressbar'

  propTypes:
    router: React.PropTypes.instanceOf(Immutable.Map)
    rules: React.PropTypes.object.isRequired
    onPopstate: React.PropTypes.func.isRequired

  componentDidMount: ->
    window.addEventListener 'popstate', this.onPopstate

  conponentWillUnMount: ->
    window.removeEventListener 'popstate', @onPopstate

  onPopstate: ->
    info = utilPath.getCurrentInfo utilPath.expandRoutes(@props.rules)
    @props.onPopstate info

  render: ->
    routes = utilPath.expandRoutes(@props.rules)
    address = utilPath.makeAddress routes, @props.router
    if location.search?
      oldAddress = "#{location.pathname}#{location.search}"
    else
      oldAddress = location.pathname
    if oldAddress isnt address
      history.pushState null, null, address
    div className: 'addressbar'
