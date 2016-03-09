React = require('react/addons')
Immutable = require('immutable')

test = require '../../test'
actions = require('../actions')
routes = require('../routes')
updater = require '../updater'

Devtools = React.createFactory require('actions-recorder/lib/devtools')
Addressbar = React.createFactory(require('../addressbar'))

a = React.createFactory('a')
div = React.createFactory('div')
pre = React.createFactory('pre')
span = React.createFactory('span')

module.exports = React.createClass
  displayName: 'app-page'

  mixins: [ React.addons.pureRenderMixin ]

  propTypes: store: React.PropTypes.instanceOf(Immutable.Map)

  goDemo: ->
    actions.go
      name: 'demo'
      data: null
      query: {}
  goHome: ->
    actions.go
      name: 'home'
      data: null
      query: {}
  goSkip: ->
    actions.go
      name: 'skip'
      data: null
      query: {}
  goTeam: ->
    actions.go
      name: 'team'
      data: teamId: '12'
      query: {}
  goRoom: ->
    actions.go
      name: 'room'
      data:
        teamId: '23'
        roomId: '34'
      query: {}
  goQuery: ->
    actions.go
      name: 'room'
      data:
        teamId: '23'
        roomId: '34'
      query: isPrivate: 'true'
  goChinese: ->
    actions.go
      name: 'chinese'
      data:
        name: '中文'
      query:
        '中文': '中文'

  onPopstate: (info, event) ->
    actions.go info.toJS()

  onTestClick: ->
    test.run()

  renderAddress: ->
    Addressbar
      route: @props.store.get('router')
      rules: routes
      onPopstate: @onPopstate
      inHash: false

  renderDevtools: ->
    Devtools
      records: @props.core.records
      pointer: @props.core.pointer
      isTravelling: @props.core.isTravelling
      updater: updater
      store: @props.store
      initial: @props.core.initial
      width: 800
      height: window.innerHeight

  renderBanner: ->
    div className: 'bannr',
      div className: 'heading level-2', 'Router View for React'
      div className: '',
        span(null, 'Location bar is a view! So we time travel! ')
        a href: 'http://github.com/mvc-works/router-view', 'Read more on GitHub'
        div className: 'button is-attract', onClick: @onTestClick, 'Test'

  renderUI: ->
    div className: 'app-ui',
      @renderBanner()
      @renderAddress()
      div(className: 'page-divider')
      div className: 'line',
        div className: 'button is-attract', onClick: @goHome, 'goHome'
        div className: 'button is-attract', onClick: @goDemo, 'goDemo'
        div className: 'button is-attract', onClick: @goSkip, 'goSkip'
        div className: 'button is-attract', onClick: @goTeam, 'goTeam'
        div className: 'button is-attract', onClick: @goRoom, 'goRoom'
        div className: 'button is-attract', onClick: @goQuery, 'goQuery'
        div className: 'button is-attract', onClick: @goChinese, 'goChinese'
      div className: 'line',
        span(null, 'Also try: ')
        a({ href: '/skip/whatever/path' }, '/skip/whatever/path')
      div(className: 'page-divider')
      div { className: 'line' },
        span({ className: 'is-bold' }, 'Store is:')
      pre { className: 'page-content' },
        JSON.stringify(@props.store, null, 2)

  render: ->
    div className: 'app-page',
      @renderUI()
      div className: 'devtools-layer',
        @renderDevtools()
