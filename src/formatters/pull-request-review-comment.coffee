{formatComment} = require './formatter-helpers'

module.exports = ({data}) ->
  comment = data.comment
  pullRequest = data.pull_request
  repo = data.repo

  """
  #{comment.user.login} commented on Pull Request ##{pullRequest.number} on #{repo.full_name}

  #{formatComment(comment.body)}

  #{comment.html_url}
  """
