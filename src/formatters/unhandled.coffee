module.exports = (data) ->
  "GitHub sent an event I don't understand:\n\n#{JSON.stringify(data, null, 2)}"
