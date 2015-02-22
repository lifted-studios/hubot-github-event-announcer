faker = require 'faker'

formatter = require '../../src/formatters/pull-request'
{githubRepo} = require '../helpers'

describe 'Pull Request Formatter', ->
  [event, name, number, repo, title, url] = []

  beforeEach ->
    name = faker.internet.userName()
    number = faker.helpers.randomNumber()
    repo = githubRepo()
    title = faker.lorem.sentence()
    url = faker.internet.avatar()

    event =
      type: 'pull_request'
      data:
        action: 'opened'
        html_url: url
        number: number
        pull_request:
          title: title
          repo:
            full_name: repo
          user:
            login: name

  it 'formats an open pull request event', ->
    event.data.action = 'opened'

    expect(formatter(event)).toEqual """
      #{name} opened Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats a close without merging pull request event', ->
    event.data.action = 'closed'
    event.data.pull_request.merged = false

    expect(formatter(event)).toEqual """
      #{name} closed Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats a merge pull request event', ->
    event.data.action = 'closed'
    event.data.pull_request.merged = true

    expect(formatter(event)).toEqual """
      #{name} merged Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats a reopen pull request event', ->
    event.data.action = 'reopened'

    expect(formatter(event)).toEqual """
      #{name} reopened Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """
