{fixtureContent} = require '../helpers'
formatter = require '../../src/formatters/ping'

describe 'Ping Formatter', ->
  it 'formats a ping event', ->
    event =
      data: fixtureContent('ping.json')

    expect(formatter(event)).toEqual """
      GitHub sent a Webhook Ping event: #{event.data.zen}

      #{event.data.hook.url}
      """
