faker = require 'faker'

module.exports =
  githubRepo: ->
    "#{faker.lorem.words(1)}/#{faker.lorem.words(1)}"
