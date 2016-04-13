module.exports = (event) ->
  switch event.data.action
    when 'opened', 'closed', 'reopened' then openEvent(event)
    when 'assigned', 'unassigned' then assignEvent(event)
    when 'labeled', 'unlabeled' then labelEvent(event)

openEvent = ({data}) ->
  pullRequest = data.pull_request
  sender = data.sender
  repo = data.repository
  verb =
    if pullRequest.merged
      'merged'
    else
      data.action

  """
  #{sender.login} #{verb} Pull Request ##{data.number} on #{repo.full_name}
  Title: #{pullRequest.title}

  #{pullRequest.html_url}
  """

assignEvent = ({data}) ->
  pullRequest = data.pull_request
  repo = data.repository
  sender = data.sender
  verb = data.action
  assignee = data.assignee.login
  assignee = 'themselves' if assignee is sender.login

  """
  #{sender.login} #{verb} #{assignee} to Pull Request ##{data.number} on #{repo.full_name}
  Title: #{pullRequest.title}

  #{pullRequest.html_url}
  """

labelEvent = ({data}) ->
  pullRequest = data.pull_request
  repo = data.repository
  sender = data.sender
  label = data.label.name
  verb =
    switch data.action
      when 'labeled' then 'added'
      when 'unlabeled' then 'removed'

  """
  #{sender.login} #{verb} the label #{label} to Pull Request ##{data.number} on #{repo.full_name}
  Title: #{pullRequest.title}

  #{pullRequest.html_url}
  """
