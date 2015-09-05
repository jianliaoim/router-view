
var
  recorder $ require :actions-recorder

= exports.internalCommit $ \ ()
  recorder.dispatch :actions-recorder/commit

= exports.internalSwitch $ \ ()
  recorder.dispatch :actions-recorder/switch

= exports.internalReset $ \ ()
  recorder.dispatch :actions-recorder/reset

= exports.internalPeek $ \ (position)
  recorder.dispatch :actions-recorder/peek position

= exports.internalDiscard $ \ ()
  recorder.dispatch :actions-recorder/discard

= exports.go $ \ (info)
  console.log :go info
  recorder.dispatch :router/go info

