# frozen_string_literal: true

require 'storedsafe/parser/raw_parser'

require_relative 'config/configurable'
require_relative 'config/rc_reader'
require_relative 'config/env_reader'

module StoredSafe
  ##
  # Contains modules and classes related to parsing configuration sources and
  # merging said configurations into an object including the Configurable mixin.
  # @see StoredSafe::Config::Configurable for more information about the
  #   available fields for configuration.
  module Config
    # Default configuration values
    DEFAULTS = {
      config_sources: [
        RcReader.parse_file,
        EnvReader.parse_env
      ],
      version: '1.0',
      parser: Parser::RawParser
    }.freeze

    ##
    # Allocate uninitialized values in a configurable object with
    # values from environment variables or an RC-file.
    # @param [StoredSafe::Config::Configurable] configurable
    def self.apply(configurable)
      apply_config(configurable, DEFAULTS)

      configurable.config_sources.each do |config|
        apply_config(configurable, config)
      end
    end

    def self.apply_config(configurable, config)
      config.each do |key, val|
        key = "@#{key}"
        if configurable.instance_variable_get(key).nil?
          configurable.instance_variable_set(key, val)
        end
      end
    end

    private_class_method :apply_config
  end
end
