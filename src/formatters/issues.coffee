# Public: Formats the [issues event](https://developer.github.com/v3/activity/events/types/#issuesevent)
# for announcement into the chat.
#
# ## Example
#
# ```
# user-name opened Issue #23 on foo/bar
# Title: 'Add some feature'
#
# https://github.com/foo/bar/issue/23
# ```
#
# * `event` Push event.
#
# Returns a {String} containing the announcement.
module.exports = (event) ->
  data = event.data
  switch data.action
    when 'opened', 'closed', 'reopened'
      openAction(data)
    when 'labeled', 'unlabeled'
      labelAction(data)
    when 'assigned', 'unassigned'
      assignAction(data)

assignAction = (data) ->
  {action, assignee, issue, repository, sender} = data

  assigneeName =
    if sender.login is assignee.login
      'themselves'
    else
      assignee.login

  preposition =
    switch action
      when 'assigned' then 'to'
      when 'unassigned' then 'from'

  """
  #{sender.login} #{data.action} #{assigneeName} #{preposition} Issue ##{issue.number} on #{repository.full_name}
  Title: #{issue.title}

  #{issue.html_url}
  """

labelAction = (data) ->
  {action, issue, label, repository, sender} = data

  switch action
    when 'labeled'
      verb = 'added'
      preposition = 'to'
    when 'unlabeled'
      verb = 'removed'
      preposition = 'from'

  """
  #{sender.login} #{verb} the label '#{label.name}' #{preposition} Issue ##{issue.number} on #{repository.full_name}
  Title: #{issue.title}

  #{issue.html_url}
  """

openAction = (data) ->
  {action, issue, repository, sender} = data
  userName = sender?.login ? issue.user.login

  """
  #{userName} #{action} Issue ##{issue.number} on #{repository.full_name}
  Title: #{issue.title}

  #{issue.html_url}
  """
