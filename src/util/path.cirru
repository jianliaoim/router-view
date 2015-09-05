
var
  Immutable $ require :immutable
  prelude $ require :./prelude

var queryParse $ \ (info chunks)
  cond (is chunks.size 0) info
    chunks.map $ \ (chunk)
      prelude.let (chunk.split :=) $ \ (pieces)
        var
          ([]~ key value) pieces
        queryParse
          info.set key value
          chunks.slice 1

= exports.parse $ \ (segment)
  var
    ([]~ chunkPath chunkQuery) (segment.split :?)
  = chunkQuery $ or chunkQuery :
  Immutable.fromJS $ {}
    :path $ chunkPath.split :/
    :query $ queryParse (Immutable.Map)
      Immutable.fromJS (chunkQuery.split :&)

= exports.stringify $ \ (info)
  var stringPath $ ... info
    get :path
    join :/
  var stringQuery $ ... info
    get :query
    map $ \ (value key)
      + key := value
    join :&
  + stringPath :? stringQuery

= exports.fill $ \ (pieces data)
  pieces.map $ \ (chunk)
    cond (is (chunk.substr 0 1) ::)
      data.get (chunk.substr 1)
      , chunk

var matchHelper $ \ (pieces rulePieces result)
  cond
    and (is pieces.size 0) (is rulePieces.size 0)
    , result
    cond (result.get :end) result
      prelude.let (rulePieces.get 0) $ \ (rule)
        prelude.let (pieces.get 0) $ \ (piece)
          cond (is (rule.substr 0 1) ::)
            result.setIn ([] :data (rule.substr 1)) piece
            result.set :end (is rule piece)

= exports.match $ \ (pieces rulePieces)
  matchHelper pieces rulePieces
    Immutable.fromJS $ {} (:end false) (:data ({}))