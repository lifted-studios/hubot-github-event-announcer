module.exports = (event) ->
  "GitHub sent an event I don't understand:\n\n#{JSON.stringify(event.data, null, 2)}"
