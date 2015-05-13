# Description:
#   Adds GitHub event hooks to GitHub repositories.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GITHUB_EVENT_DEFAULT_ROOM - Room name of the default room to announce events in
#   HUBOT_GITHUB_EVENT_SECRET - Secret that matches the value stored in the GitHub hook definition
#
# Commands:
#   hubot listen for events on <user>/<repo>
#
# Notes:
#   None
#
# Author:
#   lee-dohm

HookManager = require './hook-manager'

module.exports = (robot) ->
  robot.respond /listen for (GitHub)? events on ([^/]+)\/(.+)$/i, (response) ->
    user = response.match[2]
    repo = response.match[3]

    robot.logger.info "Request to add GitHub events hook to #{user}/#{repo} received"

    hookManager = new HookManager(robot, response)
    hookManager.addHook(user, repo)
