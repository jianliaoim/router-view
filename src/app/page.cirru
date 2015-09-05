
var
  React $ require :react/addons
  Immutable $ require :immutable

var
  actions $ require :../actions
  routes $ require :../routes

var
  Controller $ React.createFactory
    require :actions-recorder/lib/panel/controller
  Addressbar $ React.createFactory $ require :../addressbar
  a $ React.createFactory :a
  div $ React.createFactory :div
  pre $ React.createFactory :pre
  span $ React.createFactory :span

= module.exports $ React.createClass $ {}
  :displayName :app-page
  :mixins $ [] React.addons.pureRenderMixin

  :propTypes $ {}
    :store $ React.PropTypes.instanceOf Immutable.Map

  :goDemo $ \ ()
    actions.go $ {}
      :name :demo
      :data null
      :query $ {}

  :goHome $ \ ()
    actions.go $ {}
      :name :home
      :data null
      :query $ {}

  :goSkip $ \ ()
    actions.go $ {}
      :name :skip
      :data null
      :query $ {}

  :goTeam $ \ ()
    actions.go $ {}
      :name :team
      :data $ {}
        :teamId :12
      :query $ {}

  :goRoom $ \ ()
    actions.go $ {}
      :name :room
      :data $ {}
        :teamId :23
        :roomId :34
      :query $ {}

  :goQuery $ \ ()
    actions.go $ {}
      :name :room
      :data $ {}
        :teamId :23
        :roomId :34
      :query $ {}
        :isPrivate :true

  :onPopstate $ \ (info)
    actions.go (info.toJS)

  :renderAddress $ \ ()
    Addressbar $ {}
      :router $ this.props.store.get :router
      :rules routes
      :onPopstate this.onPopstate

  :renderController $ \ ()
    Controller $ {}
      :records this.props.core.records
      :pointer this.props.core.pointer
      :isTravelling this.props.core.isTravelling
      :onCommit actions.internalCommit
      :onSwitch actions.internalSwitch
      :onReset actions.internalReset
      :onPeek $ \ (position) (actions.internalPeek position)
      :onDiscard actions.internalDiscard

  :renderBanner $ \ ()
    div ({} (:className :bannr))
      div ({} (:className ":heading level-2")) ":Router View for React"
      div ({} (:className ":line is-minor"))
        span null ":Location bar is a view! So we time travel! "
        a ({} (:href :http://github.com/mvc-works/router-view)) ":Read more on GitHub"

  :render $ \ ()
    div ({} (:className :app-page))
      this.renderBanner
      this.renderAddress
      this.renderController
      div ({} (:className :page-divider))
      div ({} (:className :line))
        div ({} (:className ":button is-attract") (:onClick this.goHome)) :goHome
        div ({} (:className ":button is-attract") (:onClick this.goDemo)) :goDemo
        div ({} (:className ":button is-attract") (:onClick this.goSkip)) :goSkip
        div ({} (:className ":button is-attract") (:onClick this.goTeam)) :goTeam
        div ({} (:className ":button is-attract") (:onClick this.goRoom)) :goRoom
        div ({} (:className ":button is-attract") (:onClick this.goQuery)) :goQuery
      div ({} (:className :line))
        span null ":Also try: "
        a ({} (:href :/skip/whatever/path)) :/skip/whatever/path
      div ({} (:className :page-divider))
      div ({} (:className :line))
        span ({} (:className :is-bold)) ":Store is:"
      pre ({} (:className :page-content))
        JSON.stringify this.props.store null 2
