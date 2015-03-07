faker = require 'faker'

formatter = require '../../src/formatters/watch'
{githubRepo} = require '../helpers'

describe 'Create Formatter', ->
  [event, name, repo, url] = []

  beforeEach ->
    name = faker.internet.userName()
    repo = githubRepo()
    url = faker.internet.avatar()

    event =
      type: 'watch'
      data:
        repository:
          full_name: repo
          html_url: url
        sender:
          login: name

  it 'formats a watch event', ->
    expect(formatter(event)).toEqual """
      #{name} starred the repository #{repo}

      #{url}
      """
