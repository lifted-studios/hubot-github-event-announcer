module.exports = ({data}) ->
  repo = data.repository
  sender = data.sender

  """
  #{sender.login} deleted #{data.ref_type} #{data.ref} on #{repo.full_name}
  """
