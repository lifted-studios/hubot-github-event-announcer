{ordinal} = require './helpers'

# Public: Formats the [push event](https://developer.github.com/v3/activity/events/types/#pushevent)
# for announcement into the chat.
#
# ## Example
#
# ```
# lee-dohm pushed 1 commit to lifted-studios/lifted-hubot
#  * Add a small description to unhandled event messages
#
# https://github.com/lifted-studios/lifted-hubot/compare/59c6a6a81a0a...651ef72811f2
# ```
#
# * `data` Push event data.
#
# Returns a {String} containing the announcement.
module.exports = (data) ->
  message = "#{data.pusher.name} pushed #{ordinal(data.commits.length, 'commit')} to #{data.repository.full_name}"
  message += "\n * #{commit.message}" for commit in data.commits
  message += "\n\n#{data.compare}"
  message
