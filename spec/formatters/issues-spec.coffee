faker = require 'faker'
formatter = require '../../src/formatters/issues'
{githubRepo} = require '../helpers'

describe 'Issues Formatter', ->
  [event, label, opener, number, otherName, repo, sender, title, url] = []

  beforeEach ->
    label = faker.lorem.words(1)
    opener = faker.internet.userName()
    number = faker.helpers.randomNumber()
    otherName = faker.internet.userName()
    repo = githubRepo()
    title = faker.lorem.sentence()
    url = faker.internet.avatar()
    sender = faker.internet.userName()

    event =
      data:
        issue:
          number: number
          title: title
          user:
            login: opener
          html_url: url
        repository:
          full_name: repo

  it 'formats an issue open event', ->
    event.data.action = 'opened'

    expect(formatter(event)).toEqual """
      #{opener} opened Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue close event', ->
    event.data.action = 'closed'
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} closed Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue reopen event', ->
    event.data.action = 'reopened'
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} reopened Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue label event', ->
    event.data.action = 'labeled'
    event.data.label =
      name: label
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} added the label '#{label}' to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unlabel event', ->
    event.data.action = 'unlabeled'
    event.data.label =
      name: label
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} removed the label '#{label}' from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue assign event', ->
    event.data.action = 'assigned'
    event.data.assignee =
      login: otherName
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} assigned #{otherName} to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue assign event where the assigner is the assignee', ->
    event.data.action = 'assigned'
    event.data.assignee =
      login: sender
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} assigned themselves to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unassign event', ->
    event.data.action = 'unassigned'
    event.data.assignee =
      login: otherName
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} unassigned #{otherName} from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unassign event where the unassigner is the assignee', ->
    event.data.action = 'unassigned'
    event.data.assignee =
      login: sender
    event.data.sender =
      login: sender

    expect(formatter(event)).toEqual """
      #{sender} unassigned themselves from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """
