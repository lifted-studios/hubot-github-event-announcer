module.exports = (event) ->
  switch event.data.action
    when 'opened', 'closed', 'reopened' then openEvent(event)
    when 'assigned', 'unassigned' then assignEvent(event)
    when 'labeled', 'unlabeled' then labelEvent(event)

openEvent = (event) ->
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

assignEvent = (event) ->
  data = event.data
  pullRequest = data.pull_request
  verb = data.action
  assignee = data.assignee.login
  assignee = 'themselves' if assignee is pullRequest.user.login

  """
  #{pullRequest.user.login} #{verb} #{assignee} to Pull Request ##{data.number} on #{pullRequest.repo.full_name}
  Title: #{pullRequest.title}

  #{data.html_url}
  """

labelEvent = (event) ->
  data = event.data
  pullRequest = data.pull_request
  label = data.label.name
  verb =
    switch data.action
      when 'labeled' then 'added'
      when 'unlabeled' then 'removed'

  """
  #{pullRequest.user.login} #{verb} the label #{label} to Pull Request ##{data.number} on #{pullRequest.repo.full_name}
  Title: #{pullRequest.title}

  #{data.html_url}
  """
