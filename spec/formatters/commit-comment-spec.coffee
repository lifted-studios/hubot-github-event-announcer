faker = require 'faker'

formatter = require '../../src/formatters/commit-comment'
{githubRepo, hash, randomNumber} = require '../helpers'

describe 'Commit Comment Formatter', ->
  [content, event, name, repo, sha, url] = []

  beforeEach ->
    paragraphs = faker.lorem.paragraphs()
    name = faker.internet.userName()
    repo = githubRepo()
    sha = hash()
    url = faker.internet.avatar()

    lines = paragraphs.split("\n")
    outputLines = []
    outputLines.push("> #{line}") for line in lines
    content = outputLines.join("\n")

    event =
      type: 'commit_comment'
      data:
        comment:
          body: paragraphs
          commit_id: sha
          html_url: url
          user:
            login: name
        repository:
          full_name: repo

  it 'formats the commit comment event', ->
    expect(formatter(event)).toEqual """
      #{name} commented on commit #{sha[0...8]} on #{repo}

      #{content}

      #{url}
      """
