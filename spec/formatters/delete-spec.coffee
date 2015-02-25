faker = require 'faker'

formatter = require '../../src/formatters/delete'
{githubRepo, randomNumber} = require '../helpers'

describe 'Delete Formatter', ->
  [event, name, repo, url] = []

  beforeEach ->
    name = faker.internet.userName()
    repo = githubRepo()
    url = faker.internet.avatar()

    event =
      type: 'delete'
      data:
        repository:
          full_name: repo
        sender:
          login: name

  it 'formats a tag delete event', ->
    event.data.ref_type = 'tag'
    event.data.ref = 'v0.1.0'

    expect(formatter(event)).toEqual """
      #{name} deleted tag v0.1.0 on #{repo}
      """

  it 'formats a branch delete event', ->
    event.data.ref_type = 'branch'
    event.data.ref = 'new_branch'

    expect(formatter(event)).toEqual """
      #{name} deleted branch new_branch on #{repo}
      """
