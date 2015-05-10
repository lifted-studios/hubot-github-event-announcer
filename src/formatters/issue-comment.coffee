{formatComment} = require './formatter-helpers'

module.exports = (event) ->
  comment = event.data.comment
  issue = event.data.issue
  repo = event.data.repository

  body = stripQuotes(comment.body)

  """
  #{comment.user.login} commented on Issue ##{issue.number} in #{repo.full_name}

  #{formatComment(body)}

  #{comment.html_url}
  """

stripQuotes = (text) ->
  lines = text.split("\n")
  lines = (line for line in lines when not line.match(/^>/))
  lines.join("\n")
