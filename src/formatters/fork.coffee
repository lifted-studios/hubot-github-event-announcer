module.exports = ({data}) ->
  forkee = data.forkee
  repo = data.repository
  sender = data.sender

  """
  #{sender.login} forked the repository #{repo.full_name} to #{forkee.full_name}

  #{forkee.html_url}
  """
