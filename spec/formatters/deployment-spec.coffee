faker = require 'faker'

formatter = require '../../src/formatters/deployment'
{githubRepo, hash} = require '../helpers'

describe 'Deployment Formatter', ->
  [description, event, name, repo, sha] = []

  beforeEach ->
    description = faker.lorem.sentence()
    name = faker.internet.userName()
    repo = githubRepo()
    sha = hash()

    event =
      type: 'deployment'
      data:
        deployment:
          creator:
            login: name
          description: description
          environment: 'production'
          name: repo
          sha: sha

  it 'formats the deployment event', ->
    expect(formatter(event)).toEqual """
      #{name} started a deployment of #{sha[0...8]} in #{repo} to production
      Description: #{description}
      """
