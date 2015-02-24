# Formatters

This module has a very small core for receiving calls from hooks and announcing messages to the chat. Between those two points, all the other functionality is provided by specialized functions called formatters.

## Contract

A formatter is a CoffeeScript function that:

* Accepts an event object which consists of:
    * `data` &mdash; The parsed JSON body of the web request
    * `id` &mdash; ID of the web request
    * `robot` &mdash; Reference to the robot to access other services like the logger
    * `room` &mdash; Room to announce the event to
    * `signature` &mdash; Signature for validating the web request
    * `type` &mdash; Type of event
* Returns a message to be sent to the room or `undefined` if no message should be sent

For a given event type, the formatter is supposed to take care of everything short of actually sending the message to the room. So any logging, error detection or what have you that may be specific to the event should be done by the formatter. For example, the push event is normally formatted and announced. But if the push event consists of zero commits (which is the case when a push of tags happens) the push event should be logged, but *not* announced. This determination and logging is up to the push event formatter.
