
var
  React $ require :react
  Immutable $ require :immutable
  utilPath $ require :./util/path

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
    var info $ utilPath.parse address
    var targetRule $ this.state.rules.find $ \ (rule)
      utilPath.match (info.get :path) (rule.get :path)
    if (? targetRule)
      do
        this.props.onPopstate info
      do
        throw $ + ":Case not covered in rules: " address
    return undefined

  :renderAddress $ \ ()
    var info $ this.state.rules.get (this.getName)
    var data (this.getData)
    utilPath.stringify
      info.update :path $ \ (pieces)
        utilPath.fill (info.get :path) data

  :render $ \ ()
    var address (this.renderAddress)
    if (isnt location.pathname address) $ do
      history.pushState null null address
    div ({} (:className :addressbar))
