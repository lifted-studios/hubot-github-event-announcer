# Manages the event lifecycle.
class EventManager
  # Initializes a manager for the given Robot.
  #
  # * `robot` Hubot to work with to handle events.
  constructor: (@robot) ->

  # Public: Announces the event.
  #
  # * `event` Event to announce.
  # * `callback` {Function} that accepts:
  #   * `room` Room {String} to announce the event to.
  #   * `message` Message {String} to use to announce the event.
  announceEvent: (event, callback) ->
    try
      formatters = @getFormatters()
      formatter = formatters[event.type] ? formatters.unhandled
      message = formatter(event)

      if message
        callback(event.room, message)
      else
        @robot.logger.info "Formatter for #{event.type} event refused to format:
          #{JSON.stringify(event, null, 2)}"

    catch err
      if process.env.HUBOT_GITHUB_EVENT_ANNOUNCE_EXCEPTIONS
        @robot.messageRoom event.room, """
          Exception occurred while formatting #{event.type} event

          #{JSON.stringify(err, null, 2)}
          """

      @robot.emit 'error', err, "Exception occurred while formatting #{event.type} event"

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
  receiveHook: (req, callback) ->
    event =
      data: req.body
      id: req.get('X-Github-Delivery')
      room: req.query.room ? process.env.HUBOT_GITHUB_EVENT_DEFAULT_ROOM
      signature: req.get('X-Github-Signature')
      type: req.get('X-Github-Event')

    callback(event)

  getFormatters: ->
    require './formatters/all'

module.exports = EventManager
