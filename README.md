# Hubot GitHub Event Announcer

Announces [GitHub webhook events][webhooks]. Gotta catch 'em all!

Currently supports:

1. Commit Comment events
1. Create events
1. Delete events
1. Deployment events
1. Fork events
1. Issue Comment events
1. Issues events
1. Ping events
1. Pull Request events
1. Pull Request Review Comment events
1. Push events
1. Watch events

All other events it announces by giving you the JSON supplied by the webhook.

## Installation

Add the package `hubot-github-event-announcer` as a dependency in your Hubot `package.json` file.

```json
"dependencies": {
  "hubot-github-event-announcer": "0.9.4"
}
```

Run the following command to make sure the module is installed.

```bash
$ npm install hubot-github-event-announcer
```

To enable the script, add the `hubot-github-event-announcer` entry to the `external-scripts.json` file (you may need to create this file).

```json
["hubot-github-event-announcer"]
```

## Administering GitHub Web Hooks Using Hubot

Hubot can:

* List web hooks &mdash; `hubot list hooks on <user>/<repo>`
* Add GitHub event web hooks &mdash; `hubot listen for events on <user>/<repo>`

Where `user` is the GitHub user name for the repository and `repo` is the GitHub repository name. When it receives this command, it will attempt to use the GitHub API to add an event hook to the GitHub repository at `https://github.com/user/repo`. It will listen for all GitHub events.

In order for Hubot to administer hooks on your behalf, you must obtain an OAuth token and store it in the environment variable `HUBOT_GITHUB_EVENT_HOOK_TOKEN`. Also, Hubot will attempt to determine the URL where the hook can be delivered from either the `HEROKU_URL` environment variable, if deployed to Heroku, or the `HUBOT_GITHUB_EVENT_BASE_URL` environment variable.

## Configuration

The GitHub Event Announcer responds to the URL `http://hubot.example.com/hubot/github-events?room=someRoom` where:

1. `hubot.example.com` is the fully-qualified domain name of your instance of Hubot
1. `someRoom` is the name of the chat room where you want announcements to show up

It also can be configured using the following environment values:

* `HUBOT_GITHUB_EVENT_ANNOUNCE_EXCEPTIONS` &mdash; If present, announces exceptions that occur during formatting
* `HUBOT_GITHUB_EVENT_ANNOUNCE_UNHANDLED` &mdash; If present, announces events that it doesn't understand by just dumping the JSON
* `HUBOT_GITHUB_EVENT_DEFAULT_ROOM` &mdash; If no room is specified in the hook, the announcer will send events to this room
* `HUBOT_GITHUB_EVENT_SECRET` &mdash; Currently unused except when creating hooks, but will eventually be used to verify the authenticity of GitHub events

## Copyright

Copyright &copy; 2015 by [Lee Dohm](http://www.lee-dohm.com) and [Lifted Studios](http://www.liftedstudios.com). See [LICENSE][license] for details.

[license]: https://github.com/lifted-studios/hubot-github-event-announcer/blob/master/LICENSE.md
[webhooks]: https://developer.github.com/v3/activity/events/types/
