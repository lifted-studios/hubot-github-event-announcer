faker = require 'faker'

formatter = require '../../src/formatters/fork'
{githubRepo} = require '../helpers'

describe 'Fork Formatter', ->
  [event, name, otherRepo, repo, url] = []

  beforeEach ->
    name = faker.internet.userName()
    otherRepo = githubRepo()
    repo = githubRepo()
    url = faker.internet.avatar()

    event =
      type: 'fork'
      data:
        forkee:
          full_name: otherRepo
          html_url: url
        repository:
          full_name: repo
        sender:
          login: name

  it 'formats a fork event', ->
    expect(formatter(event)).toEqual """
      #{name} forked the repository #{repo} to #{otherRepo}

      #{url}
      """
