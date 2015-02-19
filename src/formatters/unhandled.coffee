module.exports = (data) ->
  "GitHub sent an unknown event:\n#{JSON.stringify(data, null, 2)}"
