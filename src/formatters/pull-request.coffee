module.exports = (event) ->
  data = event.data
  pullRequest = data.pull_request
  verb =
    if pullRequest.merged
      'merged'
    else
      data.action

  """
  #{pullRequest.user.login} #{verb} Pull Request ##{data.number} on #{pullRequest.repo.full_name}
  Title: #{pullRequest.title}

  #{data.html_url}
  """
