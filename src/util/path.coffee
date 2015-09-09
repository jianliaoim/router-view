
Immutable = require 'immutable'
prelude = require './prelude'

trimSlash = (chunk) ->
  if chunk.substr(0, 1) is '/'
    trimSlash chunk.substr(1)
  else if chunk.substr(-1) is '/'
    trimSlash chunk.substr(0, chunk.length-1)
  else chunk

queryParse = (data, chunks) ->
  if (chunks.size is 0)
    data
  else
    chunks.reduce (acc, chunk) ->
      pieces = chunk.split('=')
      {key, value} = pieces
      queryParse acc.set(key, value), chunks.slice(1)
    , data

exports.parse = (segment) ->
  [chunkPath, chunkQuery] = segment.split('?')
  chunkPath = trimSlash(chunkPath)
  chunkQuery = chunkQuery or ''
  Immutable.fromJS
    path: if (chunkPath.length > 0) then chunkPath.split '/' else []
    query: if (chunkQuery.length > 0) then queryParse(Immutable.Map(), Immutable.fromJS(chunkQuery.split('&'))) else {}

exports.stringify = (info) ->
  # console.log :stringify (info.toJS)
  stringPath = info.get('path').join('/')
  stringQuery = info.get('query')
  .map (value, key) ->
    "#{key}=#{value}"
  .join '&'

  if (stringQuery.length > 0)
    "/#{stringPath}?#{stringQuery}"
  else
    "/#{stringPath}"

exports.fill = (pieces, data) ->
  pieces.map (chunk) ->
    if chunk.substr(0, 1) == ':' then data.get(chunk.substr(1)) else chunk

matchHelper = (pieces, rulePieces, result) ->
  allLong = pieces.size > 0 and rulePieces.size > 0
  allEnd = pieces.size == 0 and rulePieces.size == 0

  switch
    when result.get('skipped') then result
    when allEnd then result
    when allLong
      rule = rulePieces.get(0)
      piece = pieces.get(0)
      switch
        when rule is '~' then result.set 'skipped', true
        when rule.substr(0, 1) is ':'
          newResult = result.setIn(['data', rule.substr(1)], piece)
          matchHelper pieces.slice(1), rulePieces.slice(1), newResult
        when rule is piece then matchHelper pieces.slice(1), rulePieces.slice(1), result
        else result.set 'failed', true
    else result.set 'failed', true

exports.match = (pieces, rulePieces) ->
  # console.log :match (pieces.toJS) (rulePieces.toJS)
  result = matchHelper(pieces, rulePieces, Immutable.fromJS(
    failed: false
    skipped: false
    data: {}))
  # console.log :result (result.toJS)
  result
exports.getCurrentInfo = (rules) ->
  address = location.pathname + (location.search or '')
  addressInfo = exports.parse(address)
  targetRule = rules.reduce (acc, rule) ->
    if acc.get('failed')
      result = exports.match(addressInfo.get('path'), rule.get('path'))
      result.set 'name', rule.get('name')
    else acc
  , Immutable.fromJS(failed: true)
  info = null
  if targetRule.get('failed')
    console.error 'Case not covered in rules: ' + address
  else
    info = Immutable.Map(
      name: targetRule.get('name')
      data: targetRule.get('data')
      query: addressInfo.get('query'))
  info

exports.expandRoutes = (rules) ->
  rules.map (rule, name) ->
    info = exports.parse(rule)
    info.set 'name', name
