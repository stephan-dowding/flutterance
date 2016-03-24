flutterance = require('../flutterance')

describe 'expander', ->
  describe 'choose', ->
    it 'provides blank and filled options', ->
      expect(flutterance.choose(['hello'], 0, 1)).to.have.members([null,'hello'])

    it 'provides blank and a single option for each supplied text', ->
      expect(flutterance.choose(['hello', 'hi', 'hey'], 0, 1)).to.have.members([null, 'hello', 'hi', 'hey'])
