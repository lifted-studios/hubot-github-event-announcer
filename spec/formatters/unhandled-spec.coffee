{fixtureContent} = require '../helpers'
formatter = require '../../src/formatters/unhandled'

describe 'Unhandled Formatter', ->
  it 'formats an unhandled event', ->
    event =
      data: fixtureContent('unhandled.json')

    expect(formatter(event)).toEqual """
      GitHub sent an event I don't understand:

      #{JSON.stringify(event.data, null, 2)}
      """
