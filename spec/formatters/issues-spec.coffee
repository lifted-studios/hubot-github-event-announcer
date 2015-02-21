faker = require 'faker'
formatter = require '../../src/formatters/issues'
{githubRepo} = require '../helpers'

describe 'Issues Formatter', ->
  [label, name, number, otherName, repo, title, url] = []

  beforeEach ->
    label = faker.lorem.words(1)
    name = faker.internet.userName()
    number = faker.helpers.randomNumber()
    otherName = faker.internet.userName()
    repo = githubRepo()
    title = faker.lorem.sentence()
    url = faker.internet.avatar()

  it 'formats an issue open event', ->
    event =
      data:
        action: 'opened'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo

    expect(formatter(event)).toEqual """
      #{name} opened Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue close event', ->
    event =
      data:
        action: 'closed'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo

    expect(formatter(event)).toEqual """
      #{name} closed Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue reopen event', ->
    event =
      data:
        action: 'reopened'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo

    expect(formatter(event)).toEqual """
      #{name} reopened Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue label event', ->
    event =
      data:
        action: 'labeled'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo
        label:
          name: label

    expect(formatter(event)).toEqual """
      #{name} added the label '#{label}' to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unlabel event', ->
    event =
      data:
        action: 'unlabeled'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo
        label:
          name: label

    expect(formatter(event)).toEqual """
      #{name} removed the label '#{label}' from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue assign event', ->
    event =
      data:
        action: 'assigned'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo
        assignee:
          login: otherName

    expect(formatter(event)).toEqual """
      #{name} assigned #{otherName} to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue assign event where the assigner is the assignee', ->
    event =
      data:
        action: 'assigned'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo
        assignee:
          login: name

    expect(formatter(event)).toEqual """
      #{name} assigned themselves to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unassign event', ->
    event =
      data:
        action: 'unassigned'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo
        assignee:
          login: otherName

    expect(formatter(event)).toEqual """
      #{name} unassigned #{otherName} from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unassign event where the unassigner is the assignee', ->
    event =
      data:
        action: 'unassigned'
        issue:
          number: number
          title: title
          user:
            login: name
          html_url: url
        repository:
          full_name: repo
        assignee:
          login: name

    expect(formatter(event)).toEqual """
      #{name} unassigned themselves from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """
