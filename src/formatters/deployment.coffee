module.exports = ({data}) ->
  deployment = data.deployment

  """
  #{deployment.creator.login} started a deployment of #{deployment.sha[0...8]} in #{deployment.name} to #{deployment.environment}
  Description: #{deployment.description}
  """
