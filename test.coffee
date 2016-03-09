
assert = require 'assert'
Immutable = require 'immutable'

pathUtil = require './src/path'

o = Immutable.Map()
fromJS = Immutable.fromJS

testTrimSlash = ->
  console.log "* test on trim slash"
  assert.equal pathUtil.trimSlash('/a/b/c'), 'a/b/c'
  assert.equal pathUtil.trimSlash('/a/b/'), 'a/b'

testQueryParse = ->
  console.log '* test on query parser'
  result = pathUtil.queryParse(o, fromJS('a=1&b=2'.split('&')))
  expected = {a: '1', b: '2'}
  assert.deepEqual result.toJS(), expected

testChineseQueryParse = ->
  console.log '* test on Chinese query parser'
  text = encodeURIComponent '中文'
  result = pathUtil.queryParse(o, fromJS("#{text}=#{text}".split('&')))
  expected = {'中文': '中文'}
  assert.deepEqual result.toJS(), expected

testLongQueryParse = ->
  console.log '* test on long query parser'
  longPath = 'ct=503316480&z=0&ipn=d&word=%E9%80%94%E5%AE%89&step_word=&pn=0&spn=0&di=1712569540&pi=&rn=1&tn=baiduimagedetail&is=&istype=2&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=2464434574%2C440997798&os=1619671487%2C69261469&simid=3496201219%2C355884747&adpicid=0&ln=1000&fr=&fmq=1457507365044_R&fm=&ic=0&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&ist=&jit=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fphotocdn.sohu.com%2F20111102%2FImg324265977.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3F65ss_z%26e3Bf5i7_z%26e3Bv54AzdH3Fda8888adAzdH3Fgnd9dmcl0m_z%26e3Bfip4s&gsm=0'
  result = pathUtil.queryParse(o, fromJS(longPath.split('&')))
  expected = {"gsm":"0","lm":"-1","st":"-1","ln":"1000","oriquery":"","adpicid":"0","cg":"","os":"1619671487,69261469","istype":"2","di":"1712569540","in":"","fromurl":"ippr_z2C$qAzdH3FAzdH3F65ss_z&e3Bf5i7_z&e3Bv54AzdH3Fda8888adAzdH3Fgnd9dmcl0m_z&e3Bfip4s","width":"","ipn":"d","fm":"","height":"","cl":"2","fmq":"1457507365044_R","ist":"","is":"","word":"途安","sme":"","fr":"","cs":"2464434574,440997798","ct":"503316480","spn":"0","simid":"3496201219,355884747","se":"","s":"undefined","jit":"","tab":"0","oe":"utf-8","objurl":"http://photocdn.sohu.com/20111102/Img324265977.jpg","pi":"","z":"0","ic":"0","tn":"baiduimagedetail","ie":"utf-8","rn":"1","bdtype":"0","step_word":"","face":"undefined","pn":"0"}
  assert.deepEqual result.toJS(), expected

testStringify = ->
  console.log '* test on stringify'
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
  console.log '* test on fill'
  pieces = fromJS ['team', ':teamId', 'room', ':roomId']
  data = fromJS teamId: '12', roomId: '34'
  result = pathUtil.fill pieces, data
  expected = fromJS ['team', '12', 'room', '34']
  assert.deepEqual result.toJS(), expected.toJS()

testMatch = ->
  console.log '* test on match'
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
  console.log '* test on expand rule'
  rules = fromJS [
    ['a', '/a']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'a'
    path: ['a']
    query: {}
  ]
  assert.deepEqual result.toJS(), expected

  rules = fromJS [
    ['b', '/b/2']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'b'
    path: ['b', '2']
    query: {}
  ]
  assert.deepEqual result.toJS(), expected

  rules = fromJS [
    ['c', '/c?a=1']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'c'
    path: ['c']
    query:
      a: '1'
  ]
  assert.deepEqual result.toJS(), expected

  rules = fromJS [
    ['d', '/d/?a=1']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'd'
    path: ['d']
    query:
      a: '1'
  ]
  assert.deepEqual result.toJS(), expected

  rules = fromJS [
    ['e', '/e/?a=1&b=2']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'e'
    path: ['e']
    query:
      a: '1'
      b: '2'
  ]
  assert.deepEqual result.toJS(), expected

  rules = fromJS [
    ['f', '/f/~']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'f'
    path: ['f', '~']
    query: {}
  ]
  assert.deepEqual result.toJS(), expected

  rules = fromJS [
    ['f', '/f/~?a=1']
  ]
  result = pathUtil.expandRoutes rules
  expected = [
    name: 'f'
    path: ['f', '~']
    query:
      a: '1'
  ]
  assert.deepEqual result.toJS(), expected

testMakeAddress = ->
  console.log '* test make address'
  routes = pathUtil.expandRoutes fromJS [['a', '/b/:c/d']]
  route = fromJS
    name: 'a'
    data:
      c: '1'
    query:
      a: 'x'
  result = pathUtil.makeAddress routes, route
  expected = '/b/1/d?a=x'
  assert.equal result, expected

testMakeChineseAddress = ->
  console.log '* test make chinese address'
  routes = pathUtil.expandRoutes fromJS [['a', '/中文/:name']]
  route = fromJS
    name: 'a'
    data:
      name: '中文'
    query:
      '中文': '中文'
  result = pathUtil.makeAddress routes, route
  expected = encodeURI("/中文/中文?中文=中文")
  assert.equal result, expected

# Run

exports.run = ->
  console.group "Running test..."

  testTrimSlash()
  testQueryParse()
  testChineseQueryParse()
  testLongQueryParse()
  testStringify()
  testFill()
  testMatch()
  testExpandRoutes()
  testMakeAddress()
  testMakeChineseAddress()

  console.groupEnd()
