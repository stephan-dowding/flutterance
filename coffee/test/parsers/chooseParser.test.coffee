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
    expect(fragment.mode).to.equal 'ordered'

  describe '?', ->
    it 'sets the min to 0', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]? how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 1
      expect(fragment.mode).to.equal 'ordered'

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]? how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '+', ->
    it 'sets the max to choices.length', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]+ how are you'
      expect(fragment.min).to.equal 1
      expect(fragment.max).to.equal 3
      expect(fragment.mode).to.equal 'ordered'

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]+ how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '*', ->
    it 'sets the min to 0 and max to choices.length', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]* how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 3
      expect(fragment.mode).to.equal 'ordered'

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]* how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '(n)', ->
    it 'sets the min and max to n', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey](2) how are you'
      expect(fragment.min).to.equal 2
      expect(fragment.max).to.equal 2
      expect(fragment.mode).to.equal 'ordered'

    it 'sets the min and max to maxLength for *', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey](*) how are you'
      expect(fragment.min).to.equal 3
      expect(fragment.max).to.equal 3
      expect(fragment.mode).to.equal 'ordered'

    it 'returns the remainder for (n)', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey](2) how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

    it 'throws a meaningful error if it can\'t parse the input', ->
      expect(() -> chooseParser.parse '[hello|hi|hey](two) how are you').to.throw('''
      invalid format after '('...
      it should be (n) or (n,m) where n and m are an integer or *
      ''')

  describe '(n,m)', ->
    it 'sets the min and max to n and m', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey|yo|wassup](2, 4) how are you'
      expect(fragment.min).to.equal 2
      expect(fragment.max).to.equal 4
      expect(fragment.mode).to.equal 'ordered'

    it 'sets the min and max to maxLength for *', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey|yo|wassup](2,*) how are you'
      expect(fragment.min).to.equal 2
      expect(fragment.max).to.equal 5
      expect(fragment.mode).to.equal 'ordered'

    it 'returns the remainder for (n,m)', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey](2,*) how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

    it 'throws a meaningful error if it can\'t parse the input', ->
      expect(() -> chooseParser.parse '[hello|hi|hey](1,two) how are you').to.throw('''
      invalid format after '('...
      it should be (n) or (n,m) where n and m are an integer or *
      ''')

  describe '~', ->
    it 'sets the mode to unordered', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]~ how are you'
      expect(fragment.min).to.equal 1
      expect(fragment.max).to.equal 1
      expect(fragment.mode).to.equal 'unordered'

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]~ how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

    it 'can combine with *', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]~* how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 3
      expect(fragment.mode).to.equal 'unordered'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '>', ->
    it 'sets the mode to unordered', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]> how are you'
      expect(fragment.min).to.equal 1
      expect(fragment.max).to.equal 1
      expect(fragment.mode).to.equal 'left'

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]> how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

    it 'can combine with *', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]>* how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 3
      expect(fragment.mode).to.equal 'left'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

  describe '<', ->
    it 'sets the mode to unordered', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]< how are you'
      expect(fragment.min).to.equal 1
      expect(fragment.max).to.equal 1
      expect(fragment.mode).to.equal 'right'

    it 'returns the remainder', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]< how are you'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'

    it 'can combine with *', ->
      {fragment: fragment, remainder: remainder} = chooseParser.parse '[hello|hi|hey]<* how are you'
      expect(fragment.min).to.equal 0
      expect(fragment.max).to.equal 3
      expect(fragment.mode).to.equal 'right'
      expect(fragment.choices.length).to.equal 3
      expect(remainder).to.equal ' how are you'
