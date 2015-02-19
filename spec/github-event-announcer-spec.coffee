Robot = require 'hubot/src/robot'

describe 'GitHub Event Announcer', ->
  [adapter, robot, user] = []

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false)

    robot.adapter.on 'connected', ->
      require('../src/github-event-announcer')(robot)

      user = robot.brain.userForId '1', {
        name: 'user'
        room: '#test'
      }

      adapter = robot.adapter

    robot.run()

    done()

  afterEach ->
    robot.shutdown()
