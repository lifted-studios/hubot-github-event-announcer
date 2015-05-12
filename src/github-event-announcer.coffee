# Description:
#   Announces GitHub events received via webhook to the chat rooms.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GITHUB_EVENT_ANNOUNCE_EXCEPTIONS - If present, announces exceptions during formatting
#   HUBOT_GITHUB_EVENT_ANNOUNCE_UNHANDLED - If present, announces unhandled events
#   HUBOT_GITHUB_EVENT_DEFAULT_ROOM - Room name of the default room to announce events in
#   HUBOT_GITHUB_EVENT_SECRET - Secret that matches the value stored in the GitHub hook definition
#
# Commands:
#   hubot listen for GitHub events on <user>/<repo>
#
# Notes:
#   None
#
# Author:
#   lee-dohm

fs = require 'fs'

EventManager = require './event-manager'
HookManager = require './hook-manager'

module.exports = (robot) ->
  manager = new EventManager(robot)

  robot.router.post '/hubot/github-events', (req, res) ->
    manager.receiveHook req, (event) ->
      robot.emit 'github-event', event
      res.send(204)

  robot.on 'github-event', (event) ->
    manager.announceEvent event, (room, message) ->
      robot.messageRoom(room, message)

  robot.respond /listen for GitHub events on ([^/]+)\/(.+)$/i, (msg) ->
    user = msg.match[1]
    repo = msg.match[2]

    robot.logger.info "Request to add GitHub events hook to #{user}/#{repo} received"

    manager = new HookManager(robot, msg)
    manager.addHook(user, repo)
