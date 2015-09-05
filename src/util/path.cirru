
var
  Immutable $ require :immutable
  prelude $ require :./prelude

var trimSlash $ \ (chunk)
  cond (is (chunk.substr 0 1) :/)
    trimSlash (chunk.substr 1)
    cond (is (chunk.substr -1) :/)
      trimSlash (chunk.substr 0 (- chunk.length 1))
      , chunk

var queryParse $ \ (data chunks)
  cond (is chunks.size 0) data
    chunks.map $ \ (chunk)
      prelude.let (chunk.split :=) $ \ (pieces)
        var
          ([]~ key value) pieces
        console.log :queryParse key value pieces
        queryParse
          data.set key value
          chunks.slice 1

= exports.parse $ \ (segment)
  var
    ([]~ chunkPath chunkQuery) (segment.split :?)
  = chunkPath $ trimSlash chunkPath
  = chunkQuery $ or chunkQuery :
  Immutable.fromJS $ {}
    :path $ cond (> chunkPath.length 0)
      chunkPath.split :/
      array
    :query $ cond (> chunkQuery.length 0)
      queryParse (Immutable.Map)
        Immutable.fromJS (chunkQuery.split :&)
      object

= exports.stringify $ \ (info)
  console.log :stringify (info.toJS)
  var stringPath $ ... info
    get :path
    join :/
  var stringQuery $ ... info
    get :query
    map $ \ (value key)
      + key := value
    join :&
  cond (> stringQuery.length 0)
    + :/ stringPath :? stringQuery
    + :/ stringPath

= exports.fill $ \ (pieces data)
  pieces.map $ \ (chunk)
    cond (is (chunk.substr 0 1) ::)
      data.get (chunk.substr 1)
      , chunk

var matchHelper $ \ (pieces rulePieces result)
  var
    allLong $ and (> pieces.size 0) (> rulePieces.size 0)
    allEnd $ and (is pieces.size 0) (is rulePieces.size 0)
  case true
    allEnd result
    allLong
      prelude.let (rulePieces.get 0) $ \ (rule)
        prelude.let (pieces.get 0) $ \ (piece)
          cond (is (rule.substr 0 1) ::)
            matchHelper (pieces.slice 1) (rulePieces.slice 1)
              result.setIn ([] :data (rule.substr 1)) piece
            cond (is rule piece)
              matchHelper (pieces.slice 1) (rulePieces.slice 1) result
              result.set :failed true
    else $ result.set :failed true

= exports.match $ \ (pieces rulePieces)
  console.log :match (pieces.toJS) (rulePieces.toJS)
  var result $ matchHelper pieces rulePieces
    Immutable.fromJS $ {} (:failed false) (:data ({}))
  console.log :result (result.toJS)
  return result