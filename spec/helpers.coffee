faker = require 'faker'
fs = require 'fs'
path = require 'path'

module.exports =
  fixtureContent: (name) ->
    JSON.parse(fs.readFileSync(path.join(__dirname, "fixtures/#{name}")))

  githubRepo: ->
    "#{faker.lorem.words(1)}/#{faker.lorem.words(1)}"

  randomNumber: (max, min = 0) ->
    Math.floor(Math.random() * (max - min)) + min
