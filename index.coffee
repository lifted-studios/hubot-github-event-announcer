path = require 'path'

module.exports = (robot) ->
  sourcePath = path.resolve __dirname, 'src'
  robot.load sourcePath
