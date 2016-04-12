chooseParser = require '../../parsers/chooseParser'

describe 'chooseParser', ->

  it 'throws if input does not start with [', ->
    expect(()->chooseParser.parse('hello')).to.throw 'unexpected input'

  it 'throws if [ and ] are unmatched', ->
    expect(()->chooseParser.parse('[hello')).to.throw 'missing ] after ['

  it 'creates a choose fragment with a single option', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello]'
    expect(fragment.choices.length).to.equal 1
    expect(fragment.expand()).to.have.members(['hello'])
    expect(remainder).to.be.falsey

  it 'creates a choose fragment with a multiple option', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]'
    expect(fragment.choices.length).to.equal 3
    expect(fragment.expand()).to.have.members(['hello', 'hi', 'hey'])
    expect(remainder).to.be.falsey

  it 'returns the remainder', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey] how are you'
    expect(fragment.choices.length).to.equal 3
    expect(remainder).to.equal ' how are you'

  it 'sets the min to 1', ->
    {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey] how are you'
    expect(fragment.min).to.equal 1
    expect(fragment.max).to.equal 1

  describe '?', ->
    it 'sets the min to 0', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]? how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 1

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]? how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '+', ->
    it 'sets the max to choices.length', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]+ how are you'
      expect(fragment.min).to.equal 1
      expect(fragment.max).to.equal 3

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]+ how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '*', ->
    it 'sets the min to 0 and max to choices.length', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]* how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 3

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]* how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'