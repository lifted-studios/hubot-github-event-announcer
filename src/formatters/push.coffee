{ordinal} = require './helpers'

# Public: Formats the [push event](https://developer.github.com/v3/activity/events/types/#pushevent)
# for announcement into the chat.
#
# ## Example
#
# ```
# user-name pushed 1 commit to foo/bar
#  * Add some feature
#
# https://github.com/foo/bar/compare/59c6a6a81a0a...651ef72811f2
# ```
#
# * `event` Push event.
#
# Returns a {String} containing the announcement.
module.exports = (event) ->
  data = event.data
  message = "#{data.pusher.name} pushed #{ordinal(data.commits.length, 'commit')} to #{data.repository.full_name}"
  message += "\n * #{commit.message}" for commit in data.commits
  message += "\n\n#{data.compare}"
  message
