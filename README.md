
Router View for React
----

> Location bar is a view of store

This project is based on `react` and `immutable-js`.

Demo http://router-view.mvc-works.org/

### Core ideas

In time travelling debugger, router is not controlled.
So I suggest location bar being regarded as a view of store.

### Usage

```bash
npm i --save router-view
```

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

Addressbar
  route: store.get('router')
  rules: routes
  onPopstate: (info, event) ->
  inHash: false # fallback to hash from history API
  duringLoading: false # set true to give up refreshing url
```

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
