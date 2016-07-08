
Router View for React
----

> Location bar is a view of store

This project is based on `react`, `immutable` and `actions-recorder`.

Demo http://router-view.mvc-works.org/

### Initial idea

Router is part of MVC and we can certainly divide it into M, C and V for better managements.
It's like `react-redux-router` but designed based on `actions-recorder`.

Ideas behind it: [Router is a View](https://hashnode.com/post/router-is-a-view-cil5959bn00kqa653p0y42gpu)

### Usage

```bash
npm i --save router-view
```

`M` part, add initial router object in store:

```coffee
Addressbar = require 'router-view'
pathUtil = require 'router-view/lib/path'

rules = pathUtil.expandRoutes [
  ['home', '/']
  ['demo', '/demo']
  ['skip', '/skip/~']
  ['team', '/team/:teamId']
  ['room', '/team/:teamId/room/:roomId']
  ['404', '~']
]

oldAddress = "#{location.pathname}#{location.search}" # for history API
# oldAddress = location.hash.substr(1) # for hash
router = pathUtil.getCurrentInfo rules, oldAddress
store = store.set 'router', router
```

"V" part, mount `Addressbar` component to manipulate History API:

```coffee
Addressbar
  route: store.get('router')
  rules: routes
  onPopstate: (info, event) ->
    # figure out the new router object and dispatch a `router/go` action
  inHash: false # fallback to hash from history API
  skipRendering: false # true to allow model/view inconsistency during loading
```

"C" part, connect action to store:

```coffee
switch actionType
  when 'router/go' # <--- bind this action
    router.go store, actionData
  else
    console.warn ":Unknown action type: #{actionType}"
    store
```

Read [`src/`](https://github.com/jianliaoim/router-view/tree/master/src) for details.

### DSL

`~` refers to "any path" in this library.

And in store the route information (`info`) is like:

```coffee
name: 'room'
data:
  teamId: '12'
  roomId: '34'
query:
  isPrivate: 'true'
```

Parameters and querystrings are supported. Get this from store and render the page.

### Notice

* keep in mind that `router-view` is totally based on `immutable-js`.
* if you need to route asynchronously, try set `skipRendering` to `true` during loading
* `undefined` value is eliminated on purpose, fire an issue if you think differenly.

### Theme

http://archwall.xyz/wp-content/uploads/2015/09/skyscrapers-city-sleeps-blue-ocean-skyscrapers-sky-aerial-skyline-beautiful-evening-streets-buildings-lights-traffic-night-shore-free-wallpapers.jpg

### License

MIT
