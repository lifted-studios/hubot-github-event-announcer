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
# * `data` Push event data.
#
# Returns a {String} containing the announcement.
module.exports = (data) ->
  switch data.action
    when 'opened', 'closed', 'reopened'
      openAction(data)
    when 'labeled', 'unlabeled'
      labelAction(data)
    when 'assigned', 'unassigned'
      assignAction(data)

assignAction = (data) ->
  assignee =
    if data.issue.user.login is data.assignee.login
      'themselves'
    else
      data.assignee.login

  preposition =
    switch data.action
      when 'assigned' then 'to'
      when 'unassigned' then 'from'

  """
  #{data.issue.user.login} #{data.action} #{assignee} #{preposition} Issue ##{data.issue.number} on #{data.repository.full_name}
  Title: #{data.issue.title}

  #{data.issue.url}
  """

labelAction = (data) ->
  switch data.action
    when 'labeled'
      verb = 'added'
      preposition = 'to'
    when 'unlabeled'
      verb = 'removed'
      preposition = 'from'

  """
  #{data.issue.user.login} #{verb} the label '#{data.label.name}' #{preposition} Issue ##{data.issue.number} on #{data.repository.full_name}
  Title: #{data.issue.title}

  #{data.issue.url}
  """

openAction = (data) ->
  """
  #{data.issue.user.login} #{data.action} Issue ##{data.issue.number} on #{data.repository.full_name}
  Title: #{data.issue.title}

  #{data.issue.url}
  """
