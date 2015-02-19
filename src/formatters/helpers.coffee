module.exports =
  ordinal: (size, singularNoun) ->
    noun = if size is 1 then singularNoun else pluralize(singularNoun)
    "#{size} #{noun}"

pluralize = (singularNoun) ->
  singularNoun + 's'
