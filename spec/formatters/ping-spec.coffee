{fixtureContent} = require '../helpers'
formatter = require '../../src/formatters/ping'

describe 'Ping Formatter', ->
  it 'formats a ping event', ->
    data = fixtureContent('ping.json')

    expect(formatter(data)).toEqual """
      GitHub sent a Webhook Ping event: #{data.zen}
      """
