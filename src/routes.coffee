
Immutable = require 'immutable'

module.exports = Immutable.fromJS [
  ['home', '/']
  ['demo', '/demo']
  ['skip', '/skip/~']
  ['team', 'team/:teamId']
  ['room', 'team/:teamId/room/:roomId']
  ['404', '404']
]
