faker = require 'faker'

describe 'Pull Request Formatter', ->
  [event, number] = []

  beforeEach ->
    number = faker.helpers.randomNumber()

    event =
      type: 'pull_request'
      data:
        action: 'opened'
        number: number
        pull_request:

  it 'formats an open pull request event', ->
