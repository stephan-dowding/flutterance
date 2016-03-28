flutterance = require('../flutterance')
{TreeFragment} = require('../fragments/treeFragment')

describe 'parse', ->
  it 'throws if a remainder is returned', ->
    expect(()->flutterance.parse('|hello')).to.throw(Error)

  it 'does not throw is no remainder is returned', ->
    fragment = flutterance.parse('hello')
    expect(fragment).to.be.an.instanceof(TreeFragment)
