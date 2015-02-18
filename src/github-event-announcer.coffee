# Description:
#   Announces GitHub events received via webhook to the chat rooms.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GITHUB_EVENT_DEFAULT_ROOM - Room name of the default room to announce events in.
#
# Commands:
#   None
#
# Notes:
#   None
#
# Author:
#   lee-dohm

module.exports = (robot) ->
  robot.router.post '/hubot/github-events', (req, res) ->
    receiveHook req, (event) ->
      robot.emit 'github-event', event
      res.send(204)

  robot.on 'github-event', (event) ->
    announceEvent event, (room, message) ->
      robot.messageRoom room, message

# Public: Announces the event.
#
# * `event` Event to announce.
# * `callback` {Function} that accepts:
#   * `room` Room {String} to announce the event to.
#   * `message` Message {String} to use to announce the event.
announceEvent = (event, callback) ->
  message =
    switch event.type
      when 'push' then formatPushEvent(event.data)
      else formatUnhandledEvent(event.data)

  callback(event.room, message)

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
formatPushEvent = (data) ->
  message = "#{data.pusher.name} pushed #{ordinal(data.commits.length, 'commit')} to #{data.repository.full_name}"
  message += "\n * #{commit.message}" for commit in data.commits
  message += "\n\n#{data.compare}"
  message

formatUnhandledEvent = (data) ->
  "GitHub sent an unknown event:\n#{JSON.stringify(event.data, null, 2)}"

ordinal = (size, singularNoun) ->
  noun = if size is 1 then singularNoun else pluralize(singularNoun)
  "#{size} #{noun}"

pluralize = (singularNoun) ->
  singularNoun + 's'

# Public: Receives the GitHub event webhook request.
#
# * `req` {Request} of the webhook.
# * `callback` {Function} that accepts:
#   * `event` {Object} consisting of:
#     * `data` Event data
#     * `id` Event ID
#     * `room` Room to announce the event to.
#     * `signature` Signature validating the event.
#     * `type` Type of the event.
receiveHook = (req, callback) ->
  callback
    data: req.body
    id: req.get('X-Github-Delivery')
    room: req.query.room ? process.env.HUBOT_GITHUB_EVENT_DEFAULT_ROOM
    signature: req.get('X-Github-Signature')
    type: req.get('X-Github-Event')
