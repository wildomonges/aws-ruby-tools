# frozen_string_literal: true

require 'aws-sdk-secretsmanager'
require 'singleton'
require 'json'
require 'active_support/core_ext/hash'
require 'dotenv/load'

# This class allows to get environment variable value from AWS Secret Manager.
# To have it working you should have setup your .env variables with the following variables
# AWS_REGION
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# SECRET_IDENTIFIER
#
# Usage Example:
# SecretsManager.instance.env(key: 'db_host')

class SecretsManager
  include Singleton

  attr_reader :client, :secrets_hash

  def initialize
    @client = Aws::SecretsManager::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    secrets_string = client.get_secret_value(secret_id: ENV['SECRET_IDENTIFIER']).secret_string
    @secrets_hash = JSON.parse(secrets_string).with_indifferent_access
  end

  # Gets the secret value
  # @param key [String | Symbol], the environment variable name
  # @return [String] secret value
  def env(key:)
    secrets_hash[key.to_sym]
  end
end
