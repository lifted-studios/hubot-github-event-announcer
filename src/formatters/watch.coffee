module.exports = ({data}) ->
  repo = data.repository
  sender = data.sender

  """
  #{sender.login} starred the repository #{repo.full_name}

  #{repo.html_url}
  """
