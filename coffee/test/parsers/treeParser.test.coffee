treeParser = require('../../parsers/treeParser')
{NullFragment} = require('../../fragments/nullFragment')
{LiteralFragment} = require('../../fragments/literalFragment')
{ChooseFragment} = require('../../fragments/chooseFragment')
{TreeFragment} = require('../../fragments/treeFragment')

describe 'treeParser', ->
  it 'returns a nullFragment for empty string', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('')
    expect(fragment).to.be.an.instanceof(NullFragment)
    expect(remainder).to.be.falsey

  it 'returns a nullFragment for a string starting |', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('|something')
    expect(fragment).to.be.an.instanceof(NullFragment)
    expect(remainder).to.equal('|something')

  it 'returns a nullFragment for a string starting ]', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse(']something')
    expect(fragment).to.be.an.instanceof(NullFragment)
    expect(remainder).to.equal(']something')

  it 'returns a treeFragment with a literal and nullFragment for a regular string', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('something')
    expect(fragment.left).to.be.instanceof(LiteralFragment)
    expect(fragment.right).to.be.instanceof(NullFragment)
    expect(remainder).to.be.falsey

  it 'returns a treeFragment with a literal, nullFragment and remainder for a | terminated string', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('some|thing')
    expect(fragment.left).to.be.instanceof(LiteralFragment)
    expect(fragment.right).to.be.instanceof(NullFragment)
    expect(remainder).to.equal('|thing')

  it 'returns a treeFragment with a chooseFragment and nullFragment', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('[some|thing]')
    expect(fragment.left).to.be.instanceof(ChooseFragment)
    expect(fragment.right).to.be.instanceof(NullFragment)
    expect(remainder).to.be.falsey

  it 'returns a treeFragment with a chooseFragment and treeFragment', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('[some|thing] else')
    expect(fragment.left).to.be.instanceof(ChooseFragment)
    expect(fragment.right).to.be.instanceof(TreeFragment)
    expect(remainder).to.be.falsey

  it 'returns a treeFragment with a chooseFragment and nullFragment with remainder', ->
    {fragment: fragment, remainder: remainder} = treeParser.parse('[some|thing]|boo')
    expect(fragment.left).to.be.instanceof(ChooseFragment)
    expect(fragment.right).to.be.instanceof(NullFragment)
    expect(remainder).to.equal('|boo')
