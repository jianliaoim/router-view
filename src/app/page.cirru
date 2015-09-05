
var
  React $ require :react
  Immutable $ require :immutable

var
  actions $ require :../actions

var
  Controller $ React.createFactory
    require :actions-recorder/lib/panel/controller
  Addressbar $ React.createFactory $ require :../addressbar
  div $ React.createFactory :div

= module.exports $ React.createClass $ {}
  :displayName :app-page

  :propTypes $ {}
    :store $ React.PropTypes.instanceOf Immutable.Map

  :goDemo $ \ ()
    actions.go $ {}
      :name :home
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
        :room :34
      :query $ {}

  :onPopstate $ \ (info)
    actions.go info

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
      div ({} (:onClick this.goHome)) :goHome
      div ({} (:onClick this.goDemo)) :goDemo
      div ({} (:onClick this.goTeam)) :goTeam
      div ({} (:onClick this.goRoom)) :goRoom
