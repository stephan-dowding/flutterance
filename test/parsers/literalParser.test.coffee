literalParser = require '../../parsers/literalParser'

describe 'literalParser', ->
  it 'stops at the end of the string', ->
    {fragment: fragment, remainder: remainder} = literalParser.parse('Hello')
    expect(fragment.literal).to.equal('Hello')
    expect(remainder).to.equal('')
  it 'stops on [', ->
    {fragment: fragment, remainder: remainder} = literalParser.parse('Good [Morning|Afternoon]')
    expect(fragment.literal).to.equal('Good ')
    expect(remainder).to.equal('[Morning|Afternoon]')
  it 'stops on |', ->
    {fragment: fragment, remainder: remainder} = literalParser.parse('Morning|Afternoon]')
    expect(fragment.literal).to.equal('Morning')
    expect(remainder).to.equal('|Afternoon]')
  it 'stops on ]', ->
    {fragment: fragment, remainder: remainder} = literalParser.parse('Afternoon] how are you')
    expect(fragment.literal).to.equal('Afternoon')
    expect(remainder).to.equal('] how are you')
