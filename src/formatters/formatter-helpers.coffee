module.exports =
  # Public: Formats a comment by adding the blockquote character to the beginning of each line.
  #
  # * `text` {String} containing the body of the comment.
  formatComment: (text) ->
    lines = text.split("\n")

    outputLines = []
    outputLines.push("> #{line}") for line in lines

    outputLines.join("\n")
