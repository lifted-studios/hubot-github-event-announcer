# CHANGELOG

## **v0.9.3** &mdash; *Released: 13 May 2015*

* Convert request to JSON so that it is actually accepted

## **v0.9.2** &mdash; *Released: 12 May 2015*

* Add more logging

## **v0.9.1** &mdash; *Released: 12 May 2015*

* :bug: Fix bug in responder

## **v0.9.0** &mdash; *Released: 12 May 2015*

* Add experimental command for adding GitHub event hooks

## **v0.8.0** &mdash; *Released: 10 May 2015*

* Added blockquote formatting to all comments
* Refactored the code to bring all of the event lifecycle logic under test
* [#3](https://github.com/lifted-studios/hubot-github-event-announcer/issues/3) &mdash; Now logs all received events
* [#4](https://github.com/lifted-studios/hubot-github-event-announcer/issues/4) &mdash; Created an option to announce unhandled events. *It now defaults to off.*
* [#5](https://github.com/lifted-studios/hubot-github-event-announcer/issues/5) &mdash; Uses only the first line of the commit text when formatting push events

## **v0.7.1** &mdash; *Released: 7 March 2015*

* Use sender's name for pull request events
* [#9](https://github.com/lifted-studios/hubot-github-event-announcer/issues/9) &mdash; Fix pull request event crashes
* [#8](https://github.com/lifted-studios/hubot-github-event-announcer/issues/8) &mdash; Optionally report exceptions based on the `HUBOT_GITHUB_EVENT_ANNOUNCE_EXCEPTIONS` environment variable

## **v0.7.0** &mdash; *Released: 7 March 2015*

* Added formatter for fork events
* Added formatter for watch events
* Added formatter for deployment events
* [#6](https://github.com/lifted-studios/hubot-github-event-announcer/issues/6) &mdash; Use sender's name for most issue events

## **v0.6.0** &mdash; *Released: 24 February 2015*

* Added formatter for commit comment events
* Added formatter for create events
* Added formatter for delete events
* Added formatter for pull request review comment events

## **v0.5.0** &mdash; *Released: 22 February 2015*

* Added formatter for pull request events

## **v0.4.0** &mdash; *Released: 22 February 2015*

* Added formatter for issue comments
* Updated documentation in README

## **v0.3.0** &mdash; *Released: 20 February 2015*

* Converted all formatters to accept the entire event, not just the event data
* Added this CHANGELOG :grinning:
