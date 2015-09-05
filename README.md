
Router View for React
----

> Location bar is a view, so we can time travel.

Demo http://router-view.mvc-works.org/

### Code ideas

While playing with time travel debugger, I found router not controlled by it.
After looking into that, I suggest location bar being regarded as a view from store.
This demo is based on React and Immutable Data Structure.

### Usage

This project is experimental, check source code for details.

> Code is in CirruScript. Run `gulp script` to generate JavaScript in `lib/`.

```
npm i --save router-view
```

```coffee
Addressbar = require 'router-view'
utilPath = require 'router-view/lib/util/path'

routes =
  home: '/'
  demo: '/demo'
  skip: '/skip/~'
  team: 'team/:teamId'
  room: 'team/:teamId/room/:roomId'

store = store.set 'router', utilPath.getCurrentInfo(utilPath.expandRoutes(routes))

Addressbar
  router: store.get('router')
  rules: routes
  onPopstate: (info) ->
```

`~` refers to "any path" in this program. And in store the route information is like:

```coffee
name: 'room'
data:
  teamId: '12'
  roomId: '34'
query:
  isPrivate: 'true'
```

You see, parameters and querystrings are supported.

### License

MIT
