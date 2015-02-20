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
    data =
      action: 'opened'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo

    expect(formatter(data)).toEqual """
      #{name} opened Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue close event', ->
    data =
      action: 'closed'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo

    expect(formatter(data)).toEqual """
      #{name} closed Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue reopen event', ->
    data =
      action: 'reopened'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo

    expect(formatter(data)).toEqual """
      #{name} reopened Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue label event', ->
    data =
      action: 'labeled'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo
      label:
        name: label

    expect(formatter(data)).toEqual """
      #{name} added the label '#{label}' to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unlabel event', ->
    data =
      action: 'unlabeled'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo
      label:
        name: label

    expect(formatter(data)).toEqual """
      #{name} removed the label '#{label}' from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue assign event', ->
    data =
      action: 'assigned'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo
      assignee:
        login: otherName

    expect(formatter(data)).toEqual """
      #{name} assigned #{otherName} to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue assign event where the assigner is the assignee', ->
    data =
      action: 'assigned'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo
      assignee:
        login: name

    expect(formatter(data)).toEqual """
      #{name} assigned themselves to Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unassign event', ->
    data =
      action: 'unassigned'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo
      assignee:
        login: otherName

    expect(formatter(data)).toEqual """
      #{name} unassigned #{otherName} from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """

  it 'formats an issue unassign event where the unassigner is the assignee', ->
    data =
      action: 'unassigned'
      issue:
        number: number
        title: title
        user:
          login: name
        url: url
      repository:
        full_name: repo
      assignee:
        login: name

    expect(formatter(data)).toEqual """
      #{name} unassigned themselves from Issue ##{number} on #{repo}
      Title: #{title}

      #{url}
      """
