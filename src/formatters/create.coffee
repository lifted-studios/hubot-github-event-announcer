module.exports = ({data}) ->
  switch data.ref_type
    when 'branch', 'tag' then formatBranchOrTag(data)
    else formatRepository(data)

formatBranchOrTag = (data) ->
  repo = data.repository
  sender = data.sender

  """
  #{sender.login} created #{data.ref_type} #{data.ref} on #{repo.full_name}
  """

formatRepository = (data) ->
  repo = data.repository
  sender = data.sender

  """
  #{sender.login} created repository #{repo.full_name}
  """
