faker = require 'faker'
formatter = require '../../src/formatters/issue-comment'

describe 'Issue Comment Formatter', ->
  [content, event, name, number, repo, title, url] = []

  beforeEach ->
    content = faker.lorem.paragraphs()
    name = faker.internet.userName()
    number = faker.helpers.randomNumber()
    repo = githubRepo()
    title = faker.lorem.sentence()
    url = faker.internet.avatar()

    event =
      type: 'issue_comment'
      data:
        action: 'created'
        issue:
          number: number
          title: title
        repository:
          full_name: repo
        comment:
          body: content
          html_url: url
          user:
            login: name

  it 'formats an issue comment created event', ->
    expect(formatter(event)).toEqual """
      #{name} commented on Issue ##{number} in #{repo}

      #{content}

      #{url}
      """

  it 'excludes lines starting with >', ->
    event.data.comment.body = "#{content}\n\n> foo bar baz"

    expect(formatter(event)).toEqual """
      #{name} commented on Issue ##{number} in #{repo}

      #{content}


      #{url}
      """
