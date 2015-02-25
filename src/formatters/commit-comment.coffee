module.exports = ({data}) ->
  comment = data.comment
  repo = data.repository

  """
  #{comment.user.login} commented on commit #{comment.commit_id[0...8]} on #{repo.full_name}
  Comment: #{comment.body}

  #{comment.html_url}
  """
