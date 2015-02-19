# Public: Formats the [ping event](https://developer.github.com/webhooks/#ping-event)
# for announcement into the chat.
#
# ## Example
#
# ```
# GitHub sent a Webhook Ping event: Keep it logically awesome.
# ```
#
# * `data` Event data.
#
# Returns a {String} containing the announcement.
module.exports = (data) ->
  "GitHub sent a Webhook Ping event: #{data.zen}"
