faker = require 'faker'

formatter = require '../../src/formatters/pull-request'
{githubRepo} = require '../helpers'

describe 'Pull Request Formatter', ->
  [event, label, name, number, otherName, repo, title, url] = []

  beforeEach ->
    label = faker.lorem.words(1)
    name = faker.internet.userName()
    number = faker.helpers.randomNumber()
    otherName = faker.internet.userName()
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
          user:
            login: name
        repository:
          full_name: repo

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

  it 'formats an assign pull request event', ->
    event.data.action = 'assigned'
    event.data.assignee =
      login: otherName

    expect(formatter(event)).toEqual """
      #{name} assigned #{otherName} to Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an assign pull request event when the assigner and assignee are the same person', ->
    event.data.action = 'assigned'
    event.data.assignee =
      login: name

    expect(formatter(event)).toEqual """
      #{name} assigned themselves to Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an unassign pull request event', ->
    event.data.action = 'unassigned'
    event.data.assignee =
      login: otherName

    expect(formatter(event)).toEqual """
      #{name} unassigned #{otherName} to Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an unassign pull request event when the assigner and assignee are the same person', ->
    event.data.action = 'unassigned'
    event.data.assignee =
      login: name

    expect(formatter(event)).toEqual """
      #{name} unassigned themselves to Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats a label pull request event', ->
    event.data.action = 'labeled'
    event.data.label =
      name: label

    expect(formatter(event)).toEqual """
      #{name} added the label #{label} to Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an unlabel pull request event', ->
    event.data.action = 'unlabeled'
    event.data.label =
      name: label

    expect(formatter(event)).toEqual """
      #{name} removed the label #{label} to Pull Request ##{number} on #{repo}
      Title: #{title}

      #{url}
      """
