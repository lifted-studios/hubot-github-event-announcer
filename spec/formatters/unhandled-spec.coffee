{fixtureContent} = require '../helpers'
formatter = require '../../src/formatters/unhandled'

describe 'Unhandled Formatter', ->
  it 'formats an unhandled event', ->
    data = fixtureContent('unhandled.json')

    expect(formatter(data)).toEqual """
      GitHub sent an event I don't understand:

      #{JSON.stringify(data, null, 2)}
      """
