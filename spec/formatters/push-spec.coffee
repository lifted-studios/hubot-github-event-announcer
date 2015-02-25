faker = require 'faker'
formatter = require '../../src/formatters/push'
{githubRepo} = require '../helpers'

describe 'Push Formatter', ->
  it 'formats a basic push event', ->
    name = faker.internet.userName()
    commits = [
      { message: faker.lorem.sentence() }
      { message: faker.lorem.sentence() }
      { message: faker.lorem.sentence() }
    ]
    repoName = githubRepo()
    url = faker.internet.avatar()

    event =
      data:
        commits: commits
        compare: url
        pusher:
          name: name
        repository:
          full_name: repoName

    expect(formatter(event)).toEqual """
      #{name} pushed 3 commits to #{repoName}
       * #{commits[0].message}
       * #{commits[1].message}
       * #{commits[2].message}

      #{url}
      """

  it 'returns undefined for a push with no commits', ->
    name = faker.internet.userName()
    commits = []
    repoName = githubRepo()
    url = faker.internet.avatar()

    event =
      data:
        commits: commits
        compare: url
        pusher:
          name: name
        repository:
          full_name: repoName

    expect(formatter(event)).toBeUndefined()
