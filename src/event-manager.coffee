# Manages the event lifecycle.
class EventManager
  # Initializes a manager for the given Robot.
  #
  # * `robot` Hubot to work with to handle events.
  constructor: (@robot) ->

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

module.exports = EventManager
