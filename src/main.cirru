
var
  React $ require :react
  recorder $ require :actions-recorder

require :origami-ui
require :actions-recorder/style/actions-recorder.css
require :../styles/main.css

var
  schema $ require :./schema
  updater $ require :./updater

var
  Page $ React.createFactory $ require :./app/page

var defaultInfo $ {}
  :initial schema.store
  :updater updater

recorder.setup defaultInfo

var render $ \ (store core)
  React.render
    Page $ {}
      :store store
      :core core
    , document.body

recorder.request render
recorder.subscribe render
