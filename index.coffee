fs = require 'fs'
path = require 'path'

scripts = ['github-event-announcer.coffee']

module.exports = (robot) ->
  scriptsPath = path.resolve(__dirname, 'src')

  fs.exists scriptsPath, (exists) ->
    if exists
      for script in fs.readdirSync(scriptsPath)
        if scripts? and '*' not in scripts
          robot.loadFile(scriptsPath, script) if script in scripts
        else
          robot.loadFile(scriptsPath, script)
