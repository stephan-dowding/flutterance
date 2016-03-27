mockery = require 'mockery'

chooseParser = null

describe 'chooseParser', ->
  before ->
    mockery.enable()
    mockery.registerSubstitute('./treeParser', './literalParser')
    mockery.registerAllowables ['../../parsers/chooseParser', '../fragments/chooseFragment']
    chooseParser = require '../../parsers/chooseParser'

  after ->
    mockery.deregisterAllowables ['../../parsers/chooseParser', '../fragments/chooseFragment']
    mockery.deregisterSubstitute('./treeParser')
    mockery.disable()

  it 'throws if input does not start with [', ->
    expect(()->chooseParser.parse('hello')).to.throw Error

  it 'throws if [ and ] are unmatched', ->
    expect(()->chooseParser.parse('[hello')).to.throw Error

  it 'creates a choose fragment with a single option', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello]'
    expect(fragment.choices.length).to.equal 1
    expect(fragment.choices[0].literal).to.equal 'hello'
    expect(remainder).to.be.falsey

  it 'creates a choose fragment with a multiple option', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]'
    expect(fragment.choices.length).to.equal 3
    expect(fragment.choices[0].literal).to.equal 'hello'
    expect(fragment.choices[1].literal).to.equal 'hi'
    expect(fragment.choices[2].literal).to.equal 'hey'
    expect(remainder).to.be.falsey

  it 'returns the remainder', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey] how are you'
    expect(fragment.choices.length).to.equal 3
    expect(remainder).to.equal ' how are you'
