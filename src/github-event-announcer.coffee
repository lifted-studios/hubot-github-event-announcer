# Description:
#   Announces GitHub events received via webhook to the chat rooms.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GITHUB_EVENT_DEFAULT_ROOM - Room name of the default room to announce events in.
#   HUBOT_GITHUB_EVENT_SECRET - Secret that matches the value stored in the GitHub hook definition.
#
# Commands:
#   None
#
# Notes:
#   None
#
# Author:
#   lee-dohm

fs = require 'fs'

formatters = require './formatters/all'

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
  formatter = formatters[event.type] ? formatters.unhandled
  message = formatter(event)
  callback(event.room, message)

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
  event =
    data: req.body
    id: req.get('X-Github-Delivery')
    room: req.query.room ? process.env.HUBOT_GITHUB_EVENT_DEFAULT_ROOM
    signature: req.get('X-Github-Signature')
    type: req.get('X-Github-Event')

  callback(event)
