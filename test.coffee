
assert = require 'assert'
colors = require 'colors'
Immutable = require 'immutable'

pathUtil = require './src/util/path'

o = Immutable.Map()
fromJS = Immutable.fromJS

console.log ''
console.log colors.yellow "Running test..."

testTrimSlash = ->
  console.log colors.blue "* test on trim slash"
  assert.equal pathUtil.trimSlash('/a/b/c'), 'a/b/c'
  assert.equal pathUtil.trimSlash('/a/b/'), 'a/b'

testQueryParse = ->
  console.log colors.blue '* test on query parser'
  result = pathUtil.queryParse(o, fromJS('a=1&b=2'.split('&')))
  expected = {a: '1', b: '2'}
  assert.deepEqual result.toJS(), expected

testStringify = ->
  console.log colors.blue '* test on stringify'
  info = fromJS
    path: ['a', 'b']
    query:
      a: '1'
      b: '2'
  expected = '/a/b?a=1&b=2'
  assert.equal pathUtil.stringify(info), expected

  info = fromJS
    path: ['a', 'b']
    query: {}
  expected = '/a/b'
  assert.equal pathUtil.stringify(info), expected

  info = fromJS
    path: []
    query:
      a: '1'
  expected = '/?a=1'
  assert.equal pathUtil.stringify(info), expected

testFill = ->
  console.log colors.blue '* test on fill'
  pieces = fromJS ['team', ':teamId', 'room', ':roomId']
  data = fromJS teamId: '12', roomId: '34'
  result = pathUtil.fill pieces, data
  expected = fromJS ['team', '12', 'room', '34']
  assert.deepEqual result.toJS(), expected.toJS()

testMatch = ->
  console.log colors.blue '* test on match'
  pieces = fromJS ['a', 'b', 'c', 'd']
  rule = fromJS ['a', ':x', 'c', ':y']
  result = pathUtil.match pieces, rule
  expected =
    failed: false
    skipped: false
    data:
      x: 'b'
      y: 'd'
  assert.deepEqual result.toJS(), expected

  pieces = fromJS ['a', 'b', 'c', 'd']
  rule = fromJS ['a', '~']
  result = pathUtil.match pieces, rule
  expected =
    failed: false
    skipped: true
    data: {}
  assert.deepEqual result.toJS(), expected

testExpandRoutes = ->
  console.log colors.blue '* test on expand rule'
  rules = fromJS
    a: '/a'
  result = pathUtil.expandRoutes rules
  expected =
    a:
      name: 'a'
      path: ['a']
      query: {}
  assert.deepEqual result.toJS(), expected

  rules = fromJS
    b: '/b/2'
  result = pathUtil.expandRoutes rules
  expected =
    b:
      name: 'b'
      path: ['b', '2']
      query: {}
  assert.deepEqual result.toJS(), expected

  rules = fromJS
    c: '/c?a=1'
  result = pathUtil.expandRoutes rules
  expected =
    c:
      name: 'c'
      path: ['c']
      query:
        a: '1'
  assert.deepEqual result.toJS(), expected

  rules = fromJS
    d: '/d/?a=1'
  result = pathUtil.expandRoutes rules
  expected =
    d:
      name: 'd'
      path: ['d']
      query:
        a: '1'
  assert.deepEqual result.toJS(), expected

  rules = fromJS
    e: '/e/?a=1&b=2'
  result = pathUtil.expandRoutes rules
  expected =
    e:
      name: 'e'
      path: ['e']
      query:
        a: '1'
        b: '2'
  assert.deepEqual result.toJS(), expected

  rules = fromJS
    f: '/f/~'
  result = pathUtil.expandRoutes rules
  expected =
    f:
      name: 'f'
      path: ['f', '~']
      query: {}
  assert.deepEqual result.toJS(), expected

  rules = fromJS
    f: '/f/~?a=1'
  result = pathUtil.expandRoutes rules
  expected =
    f:
      name: 'f'
      path: ['f', '~']
      query:
        a: '1'
  assert.deepEqual result.toJS(), expected

# Run

testTrimSlash()
testQueryParse()
testStringify()
testFill()
testMatch()
testExpandRoutes()
