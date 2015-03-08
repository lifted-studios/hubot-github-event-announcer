faker = require 'faker'
uuid = require 'node-uuid'

EventManager = require '../src/event-manager'
{hash} = require './helpers'

callReceiveHook = (manager, req) ->
  event = null
  manager.receiveHook req, (ev) ->
    event = ev
  event

describe 'EventManager', ->
  describe 'receiveHook', ->
    [body, eventName, guid, manager, req, robot, roomName, signature] = []

    beforeEach ->
      robot = {}
      manager = new EventManager(robot)

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
