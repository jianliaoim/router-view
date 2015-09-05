
var
  React $ require :react
  Immutable $ require :immutable
  utilPath $ require :./util/path
  prelude $ require :./util/prelude

var
  div $ React.createFactory :div

= module.exports $ React.createClass $ {}
  :displayName :addressbar

  :propTypes $ {}
    :router $ React.PropTypes.instanceOf Immutable.Map
    :rules React.PropTypes.object.isRequired
    :inHash React.PropTypes.bool
    :onPopstate React.PropTypes.func.isRequired

  :getDefaultProps $ \ ()
    {} (:hash false)

  :getInitialState $ \ ()
    {}
      :inHash $ or this.props.inHash (not $ ? window.history)
      :rules (this.expandRules)

  :componentDidMount $ \ ()
    window.addEventListener :popstate this.onPopstate

  :getName $ \ ()
    this.props.router.get :name

  :getData $ \ ()
    this.props.router.get :data

  :getQuery $ \ ()
    this.props.router.get :query

  :expandRules $ \ ()
    var rules $ Immutable.fromJS this.props.rules
    rules.map $ \ (rule name)
      var info $ utilPath.parse rule
      info.set :name name

  :onPopstate $ \ ()
    var address $ + location.pathname (or location.search :)
    var addressInfo $ utilPath.parse address
    var targetRule $ this.state.rules.reduce
      \ (acc rule)
        cond (acc.get :failed)
          prelude.let
            utilPath.match (addressInfo.get :path) (rule.get :path)
            \ (result) $ result.set :name (rule.get :name)
          , acc
      Immutable.fromJS $ {} (:failed true)
    console.log :targetRule (targetRule.toJS)
    if (targetRule.get :failed)
      do
        console.error $ + ":Case not covered in rules: " address
      do
        var info $ Immutable.Map $ {}
          :name $ targetRule.get :name
          :data $ targetRule.get :data
          :query $ addressInfo.get :query
        this.props.onPopstate info
    return undefined

  :renderAddress $ \ ()
    console.log :address (this.state.rules.toJS) (this.props.router.toJS)
    var info $ this.state.rules.get (this.getName)
    var data (this.getData)
    utilPath.stringify
      ... info
        set :path $ utilPath.fill (info.get :path) data
        set :query (this.getQuery)

  :render $ \ ()
    var address (this.renderAddress)
    var oldAddress $ cond (? location.search)
      + location.pathname location.search
      , location.pathname
    if (isnt oldAddress address) $ do
      history.pushState null null address
    div ({} (:className :addressbar))
