faker = require 'faker'
uuid = require 'node-uuid'

EventManager = require '../src/event-manager'
{hash} = require './helpers'

callAnnounceEvent = (manager, event) ->
  room = null
  message = null

  manager.announceEvent event, (rm, msg) ->
    room = rm
    message = msg

  [room, message]

callReceiveHook = (manager, req) ->
  event = null
  manager.receiveHook req, (ev) ->
    event = ev
  event

describe 'EventManager', ->
  [body, guid, manager, robot, roomName, signature] = []

  beforeEach ->
    robot = {}
    manager = new EventManager(robot)
    robot.logger =
      info: ->

    spyOn(robot.logger, 'info')

  describe 'receiveHook', ->
    [eventName, guid, req] = []

    beforeEach ->
      body = faker.lorem.paragraphs()
      eventName = faker.lorem.words(1)
      guid = uuid.v4()
      roomName = faker.lorem.words(1)
      signature = hash()

      req =
        body: body
        get: (param) ->
          switch param
            when 'X-Github-Delivery' then guid
            when 'X-Github-Signature' then signature
            when 'X-Github-Event' then eventName
        query:
          room: roomName

    it 'sets the data element', ->
      event = callReceiveHook(manager, req)

      expect(event.data).toEqual body

    it 'sets the event ID', ->
      event = callReceiveHook(manager, req)

      expect(event.id).toEqual guid

    it 'sets the room name', ->
      event = callReceiveHook(manager, req)

      expect(event.room).toEqual roomName

    it 'sets the signature', ->
      event = callReceiveHook(manager, req)

      expect(event.signature).toEqual signature

    it 'sets the event type', ->
      event = callReceiveHook(manager, req)

      expect(event.type).toEqual eventName

    describe 'when the room name is not part of the query string', ->
      oldEnv = null

      beforeEach ->
        req.query.room = undefined
        oldEnv = process.env
        process.env =
          HUBOT_GITHUB_EVENT_DEFAULT_ROOM: roomName

      afterEach ->
        process.env = oldEnv

      it 'uses the default room name', ->
        event = callReceiveHook(manager, req)

        expect(event.room).toEqual roomName

  describe 'announceEvent', ->
    [event, formatters] = []

    beforeEach ->
      formatters = manager.getFormatters()
      formatters.foo = (event) ->
        event

      spyOn(manager, 'getFormatters').andReturn(formatters)

      body = faker.lorem.paragraphs()
      guid = uuid.v4()
      roomName = faker.lorem.words(1)
      signature = hash()

      event =
        data: body
        id: guid
        room: roomName
        signature: signature
        type: 'foo'

    it 'formats the event', ->
      [_, message] = callAnnounceEvent(manager, event)

      expect(message).toEqual event

    it 'uses the event room to announce the event', ->
      [room, _] = callAnnounceEvent(manager, event)

      expect(room).toEqual roomName

    describe 'when the event type is unrecognized', ->
      beforeEach ->
        event.type = 'bar'

      it 'uses the unhandled formatter', ->
        [_, message] = callAnnounceEvent(manager, event)

        expect(message).toEqual """
          GitHub sent an event I don't understand: #{event.type}

          #{JSON.stringify(event.data, null, 2)}
          """

    describe 'when the formatter returns null', ->
      beforeEach ->
        formatters.foo = (event) ->
          null

      it 'logs a message', ->
        callAnnounceEvent(manager, event)

        expect(robot.logger.info).toHaveBeenCalled()

    describe 'when the formatter throws an exception', ->
      beforeEach ->
        formatters.foo = (event) ->
          throw new Error('An error happened')

        robot.emit = ->
        spyOn(robot, 'emit')

      it 'emits an error event', ->
        callAnnounceEvent(manager, event)

        expect(robot.emit).toHaveBeenCalled()
        expect(robot.emit.mostRecentCall.args[0]).toEqual 'error'

      describe 'and HUBOT_GITHUB_EVENT_ANNOUNCE_EXCEPTIONS is defined', ->
        oldEnv = null

        beforeEach ->
          oldEnv = process.env
          process.env =
            HUBOT_GITHUB_EVENT_ANNOUNCE_EXCEPTIONS: true

          robot.messageRoom = ->
          spyOn(robot, 'messageRoom')

        afterEach ->
          process.env = oldEnv

        it 'announces the exception', ->
          [room, _] = callAnnounceEvent(manager, event)

          expect(room).toEqual roomName
          expect(robot.messageRoom).not.toHaveBeenCalled()

        it 'still emits the error event', ->
          callAnnounceEvent(manager, event)

          expect(robot.emit).toHaveBeenCalled()
          expect(robot.emit.mostRecentCall.args[0]).toEqual 'error'
