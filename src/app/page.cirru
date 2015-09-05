
var
  React $ require :react/addons
  Immutable $ require :immutable

var
  actions $ require :../actions

var
  Controller $ React.createFactory
    require :actions-recorder/lib/panel/controller
  Addressbar $ React.createFactory $ require :../addressbar
  div $ React.createFactory :div
  pre $ React.createFactory :pre

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
      :rules $ {}
        :home :/
        :demo :/demo
        :team :team/:teamId
        :room :team/:teamId/room/:roomId
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

  :render $ \ ()
    div ({})
      this.renderAddress
      this.renderController
      div ({} (:className :line))
        div ({} (:className ":button is-attract") (:onClick this.goHome)) :goHome
        div ({} (:className ":button is-attract") (:onClick this.goDemo)) :goDemo
        div ({} (:className ":button is-attract") (:onClick this.goTeam)) :goTeam
        div ({} (:className ":button is-attract") (:onClick this.goRoom)) :goRoom
        div ({} (:className ":button is-attract") (:onClick this.goQuery)) :goQuery
      pre ({} (:className :page-content))
        JSON.stringify this.props.store null 2
