util = require 'util'

# The list of all GitHub events.
#
# See: https://developer.github.com/v3/activity/events/types/
ALL_EVENTS = ['*']

# Public: Manages GitHub event hooks.
class HookManager
  # Public: Constructs a new `HookManager`.
  #
  # * `robot` Robot used to interact with the outside world.
  # * `message` Message to use to reply back to the user.
  constructor: (@robot, @message) ->

  # Public: Adds a hook to the repository at the given GitHub `user` and `repo`.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  # * `options` {Object} containing the following options:
  #     * `room` Room name {String} to send events to for this hook.
  addHook: (user, repo, options = {}) ->
    try
      url = @buildHookUrl(user, repo, options)
      token = @getToken()

      data =
        name: 'web'
        active: true
        config:
          content_type: 'json'
          secret: process.env.HUBOT_GITHUB_EVENT_SECRET
          url: url
        events: ALL_EVENTS

      @robot.http(@buildApiUrl(user, repo))
        .header('Accept', 'application/json')
        .header('Authorization', "token #{token}")
        .header('User-Agent', 'lee-dohm')
        .post(JSON.stringify(data)) (error, response, body) =>
          if error
            @robot.logger.error util.inspect(error)
            @message.reply """
              I encountered an error while adding the GitHub events hook to #{user}/#{repo} ...

              #{error}
              """
            return

          if 200 >= response.statusCode <= 299
            @robot.logger.info util.inspect(body)
            @message.reply "I was able to successfully add the GitHub events hook"
          else
            @robot.logger.info util.inspect(body)
            reply = "Server returned the response: #{response.statusCode} #{response.statusMessage}"
            @message.reply reply

    catch e
      @message.reply e.message

  # Public: List the web hooks installed on the GitHub repository identified by the `user` and
  # `repo` names.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  listHooks: (user, repo) ->
    try
      token = @getToken()

      @robot.http(@buildApiUrl(user, repo))
        .header('Accept', 'application/json')
        .header('Authorization', "token #{token}")
        .header('User-Agent', 'lee-dohm')
        .get() (error, response, body) =>
          if error
            @robot.logger.error util.inspect(error)
            @message.reply """
              I encountered an error while listing the GitHub events hooks for #{user}/#{repo} ...

              #{error}
              """

          if 200 >= response.statusCode <= 299
            @robot.logger.info util.inspect(body)
            @message.reply body
          else
            @robot.logger.info util.inspect(body)
            reply = "Server returned the response: #{response.statusCode} #{response.statusMessage}"
            @message.reply reply

    catch e
      @message.reply e.message

  # Private: Builds the URL to use for querying the web hook API.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  #
  # Returns a {String} containing the API URL.
  buildApiUrl: (user, repo) ->
    "https://api.github.com/repos/#{user}/#{repo}/hooks"

  # Private: Builds the URL to use for receiving the web hooks.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  # * `options` {Object} containing the following options:
  #     * `room` Room name {String} to send events to for this hook.
  #
  # Returns a {String} containing the URL.
  buildHookUrl: (user, repo, options = {}) ->
    host = process.env.HEROKU_URL ? process.env.HUBOT_GITHUB_EVENT_BASE_URL

    unless host
      throw new Error('Neither HEROKU_URL nor HUBOT_GITHUB_EVENT_BASE_URL are set, cannot add hook')

    url = "#{host}/hubot/github-events"
    url += "?room=#{options.room}" if options.room

    url

  # Private: Gets the security token to use for authorization to access web hooks.
  #
  # Returns a {String} containing the token text.
  getToken: ->
    token = process.env.HUBOT_GITHUB_EVENT_HOOK_TOKEN

    unless token
      throw new Error('HUBOT_GITHUB_EVENT_HOOK_TOKEN is not set, cannot add hook')

    token

module.exports = HookManager
