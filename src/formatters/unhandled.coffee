module.exports = (event) ->
  """
  GitHub sent an event I don't understand: #{event.type}

  #{JSON.stringify(event.data, null, 2)}
  """
