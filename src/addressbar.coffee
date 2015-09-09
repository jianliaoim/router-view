
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
    inHash: React.PropTypes.bool
    onPopstate: React.PropTypes.func.isRequired

  getDefaultProps: ->
    hash: false

  getInitialState: ->
    inHash: this.props.inHash or (not window.history?)
    rules: this.expandRules()

  componentDidMount: ->
    window.addEventListener 'popstate', this.onPopstate

  getName: ->
    this.props.router.get 'name'

  getData: ->
    this.props.router.get 'data'

  getQuery: ->
    this.props.router.get 'query'

  expandRules: ->
    this.props.rules.map (rule, name) ->
      info = utilPath.parse rule
      info.set 'name', name

  onPopstate: ->
    info = utilPath.getCurrentInfo this.state.rules
    if info?
      this.props.onPopstate info

  renderAddress: ->
    # console.log :address (this.state.rules.toJS) (this.props.router.toJS)
    info = this.state.rules.get this.getName()
    data = this.getData()
    newInfo = info
    .set 'path', utilPath.fill (info.get 'path'), data
    .set 'query', this.getQuery()

    utilPath.stringify newInfo

  render: ->
    address = this.renderAddress()
    if location.search?
      oldAddress = "#{location.pathname}#{location.search}"
    else
      oldAddress = location.pathname
    if oldAddress isnt address
      history.pushState null, null, address
    div className: 'addressbar'
