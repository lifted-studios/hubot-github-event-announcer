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

      data =
        name: 'web'
        active: true
        config:
          content_type: 'json'
          secret: process.env.HUBOT_GITHUB_EVENT_SECRET
          url: url
        events: ALL_EVENTS

      @buildClient(user, repo)
        .post(JSON.stringify(data)) (error, response, body) =>
          throw error if error
          throw response unless isSuccessful(response.statusCode)
          @robot.logger.info util.inspect(body)

          @message.reply 'I was able to successfully add the GitHub events hook'

    catch e
      @handleError(e, "adding the GitHub event hook to #{user}/#{repo}")

  # Public: List the web hooks installed on the GitHub repository identified by the `user` and
  # `repo` names.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  listHooks: (user, repo) ->
    try
      @buildClient(user, repo)
        .get() (error, response, body) =>
          throw error if error
          throw response unless isSuccessful(response.statusCode)
          @robot.logger.info util.inspect(body)

          hooks = JSON.parse(body)
          @message.reply "#{user}/#{repo} has the following hooks:\n\n#{@formatHooksList(hooks)}"

    catch e
      @handleError(e, "listing the GitHub event hooks on #{user}/#{repo}")

  # Private: Builds the URL to use for querying the web hook API.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  #
  # Returns a {String} containing the API URL.
  buildApiUrl: (user, repo) ->
    "https://api.github.com/repos/#{user}/#{repo}/hooks"

  # Private: Builds the client object to use to perform API requests.
  #
  # * `user` {String} containing the GitHub user name.
  # * `repo` {String} containing the GitHub repository name.
  #
  # Returns an HTTP client {Object}.
  buildClient: (user, repo) ->
    token = @getToken()

    @robot.http(@buildApiUrl(user, repo))
      .header('Accept', 'application/json')
      .header('Authorization', "token #{token}")
      .header('User-Agent', 'lee-dohm')

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
    throw new Error('HUBOT_GITHUB_EVENT_HOOK_TOKEN is not set, cannot add hook') unless token

    token

  # Private: Formats the list of hooks for display.
  #
  # * `hooks` {Array} of hooks for the repository.
  #
  # Returns a {String} containing the list of hooks for display.
  formatHooksList: (hooks) ->
    output = []

    for hook in hooks
      switch hook.name
        when 'web' then output.push "#{hook.id}: #{hook.name} -- #{hook.config.url}"
        else output.push "#{hook.id}: #{hook.name}"

    output.join("\n")

  # Private: Handles the error by reporting it with the given message.
  #
  # * `error` {Object} describing the error.
  # * `message` {String} describing what was being done when the error occurred.
  handleError: (error, message) ->
    @robot.logger.error util.inspect(error)

    if error.statusCode
      @message.reply "Server returned: #{error.statusCode} #{error.statusMessage}"
    else
      @message.reply """
        I encountered an error while #{message}

        #{error.message}
        #{error.stack}
        """

  # Private: Determine if the HTTP response indicates the request was successful.
  #
  # * `response` {Object} containing the HTTP response.
  #
  # Returns a {Boolean} flag indicating whether the request was successful.
  isSuccessful: (response) ->
    200 >= response.statusCode < 300

module.exports = HookManager
