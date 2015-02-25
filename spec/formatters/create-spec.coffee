faker = require 'faker'

formatter = require '../../src/formatters/create'
{githubRepo, randomNumber} = require '../helpers'

describe 'Create Formatter', ->
  [content, event, label, name, number, otherName, repo, title, url] = []

  beforeEach ->
    name = faker.internet.userName()
    repo = githubRepo()
    url = faker.internet.avatar()

    event =
      type: 'create'
      data:
        repository:
          full_name: repo
        sender:
          login: name

  it 'formats a tag create event', ->
    event.data.ref_type = 'tag'
    event.data.ref = 'v0.1.0'

    expect(formatter(event)).toEqual """
      #{name} created tag v0.1.0 on #{repo}
      """

  it 'formats a branch create event', ->
    event.data.ref_type = 'branch'
    event.data.ref = 'new_branch'

    expect(formatter(event)).toEqual """
      #{name} created branch new_branch on #{repo}
      """

  it 'formats a repository create event', ->
    event.data.ref_type = 'repository'
    event.data.ref = null

    expect(formatter(event)).toEqual """
      #{name} created repository #{repo}
      """
