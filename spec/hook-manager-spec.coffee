faker = require 'faker'
util = require 'util'

HookManager = require '../src/hook-manager'

describe 'HookManager', ->
  [client, error, manager, message, oldEnv, repo, robot, url, user] = []

  beforeEach ->
    oldEnv = process.env
    process.env.HUBOT_GITHUB_EVENT_HOOK_TOKEN = '1234abcd'
    process.env.HEROKU_URL = 'http://example.com'
    process.env.HUBOT_GITHUB_EVENT_BASE_URL = 'http://base.example.com'

    client = jasmine.createSpyObj('client', ['get', 'header', 'post'])
    error = new Error('OMGWTFBBQ!!!')
    logger = jasmine.createSpyObj('logger', ['error', 'info'])
    message = jasmine.createSpyObj('message', ['reply'])
    robot = jasmine.createSpyObj('robot', ['http'])

    robot.logger = logger

    robot.http.and.returnValue(client)
    client.header.and.returnValue(client)

    repo = faker.lorem.words(1)
    user = faker.internet.userName()

    manager = new HookManager(robot, message)

  afterEach ->
    process.env = oldEnv

  it 'stores the robot', ->
    expect(manager.robot).toBe robot

  it 'stores the message', ->
    expect(manager.message).toBe message

  describe 'adding a web hook', ->
    it 'calls the correct URL', ->
      manager.addHook(user, repo)

      expect(robot.http).toHaveBeenCalledWith("https://api.github.com/repos/#{user}/#{repo}/hooks")

    it 'sends the accept header', ->
      manager.listHooks(user, repo)

      expect(client.header).toHaveBeenCalledWith('Accept', 'application/json')

    it 'sends the authorization token', ->
      manager.addHook(user, repo)

      expect(client.header).toHaveBeenCalledWith('Authorization', 'token 1234abcd')

    it 'sends the user agent header', ->
      manager.addHook(user, repo)

      expect(client.header).toHaveBeenCalledWith('User-Agent', 'lee-dohm')

    it 'replies with an error if the token is not set', ->
      delete process.env.HUBOT_GITHUB_EVENT_HOOK_TOKEN
      manager.addHook(user, repo)

      expect(client.header).not.toHaveBeenCalled()
      expect(message.reply).toHaveBeenCalled()

    describe 'post data', ->
      addHook = (user, repo, options = {}) ->
        manager.addHook(user, repo, options)
        client.post.calls.mostRecent()?.args[0]

      it 'includes the basic information', ->
        body = JSON.parse(addHook(user, repo))

        expect(body.name).toEqual 'web'
        expect(body.active).toEqual true
        expect(body.config.content_type).toEqual 'json'

      describe 'body.config.url', ->
        it 'supplies the URL based on the HEROKU_URL environment variable by default', ->
          body = JSON.parse(addHook(user, repo))

          expect(body.config.url).toEqual 'http://example.com/hubot/github-events'

        it 'uses the HUBOT_GITHUB_EVENT_BASE_URL as a backup URL', ->
          delete process.env.HEROKU_URL
          body = JSON.parse(addHook(user, repo))

          expect(body.config.url).toEqual 'http://base.example.com/hubot/github-events'

        it 'responds with an error message if neither are set', ->
          delete process.env.HEROKU_URL
          delete process.env.HUBOT_GITHUB_EVENT_BASE_URL

          addHook(user, repo)

          expect(message.reply).toHaveBeenCalled()

        it 'supplies the room name if specified', ->
          body = JSON.parse(addHook(user, repo, room: 'foo'))

          expect(body.config.url).toEqual 'http://example.com/hubot/github-events?room=foo'

      describe 'body.events', ->
        it 'lists all events', ->
          expect(JSON.parse(addHook(user, repo)).events).toEqual ['*']

  describe 'listing web hooks', ->
    it 'calls the correct URL', ->
      manager.listHooks(user, repo)

      expect(robot.http).toHaveBeenCalledWith("https://api.github.com/repos/#{user}/#{repo}/hooks")

    it 'sends the accept header', ->
      manager.listHooks(user, repo)

      expect(client.header).toHaveBeenCalledWith('Accept', 'application/json')

    it 'sends the authorization token', ->
      manager.listHooks(user, repo)

      expect(client.header).toHaveBeenCalledWith('Authorization', 'token 1234abcd')

    it 'sends the user agent header', ->
      manager.listHooks(user, repo)

      expect(client.header).toHaveBeenCalledWith('User-Agent', 'lee-dohm')

    describe 'error handling', ->
      beforeEach ->
        spyOn(manager, 'handleError')

      it 'logs an error if the token is not set', ->
        delete process.env.HUBOT_GITHUB_EVENT_HOOK_TOKEN
        manager.listHooks(user, repo)

        expect(manager.handleError).toHaveBeenCalled()

      it 'logs an error if an error is returned', ->
        client.get.and.returnValue (callback) ->
          callback(error, null, null)

        manager.listHooks(user, repo)

        expect(manager.handleError).toHaveBeenCalled()

      it 'logs an error if an unsuccessful response is returned', ->
        response =
          statusCode: 404

        client.get.and.returnValue (callback) ->
          callback(null, response, '{}')

        manager.listHooks(user, repo)

        expect(manager.handleError).toHaveBeenCalled()
