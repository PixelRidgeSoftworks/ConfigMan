# frozen_string_literal: true

require_relative 'configman/version'
require_relative 'configman/parsers/json'
require_relative 'configman/parsers/ini'
require_relative 'configman/parsers/xml'
require_relative 'configman/parsers/yaml'

module ConfigMan # rubocop:disable Metrics/ModuleLength, Style/Documentation
  class Error < StandardError; end

  @config_values = {}
  @used_modules = []
  @loaded_parser = nil
  @custom_modules = []

  EXPECTED_KEYS = {
    'API' => %w[api_endpoint api_key rate_limit],
    'Cache' => %w[cache_type host port],
    'Database' => %w[db_host db_port db_user db_password db_name],
    'Email' => %w[smtp_server smtp_port smtp_user smtp_password smtp_protocol],
    'FileStorage' => %w[storage_type cloud_provider local_path],
    'Localization' => %w[language time_zone encoding],
    'Logging' => %w[log_level log_file log_rotation]
  }.freeze

  def self.expected_keys
    EXPECTED_KEYS
  end

  # register any custom modules the user provides
  def self.register_module(file_path)
    raise ArgumentError, "File not found: #{file_path}" unless File.exist?(file_path)

    require file_path

    module_name = File.basename(file_path, '.rb').capitalize
    mod_class = Object.const_get(module_name)

    unless mod_class.respond_to?(:populate_defaults)
      raise ArgumentError, "Custom module must implement a 'populate_defaults' method"
    end

    @custom_modules ||= []
    @custom_modules << mod_class
    puts "Custom modules: #{@custom_modules.inspect}"  # Debug line
  end

  def self.used_modules
    @used_modules
  end

  # Setup ConfigMan with presets
  def self.setup(default_modules, custom_options = {})
    # Check if a parser is loaded
    raise 'No parser module loaded. Please load a parser module before calling setup.' if @loaded_parser.nil?

    final_config = {}

    # Remove parser names from default_modules
    default_modules = default_modules.reject { |mod| %w[json ini xml yaml].include?(mod.downcase) }

    # Populate defaults from built-in modules
    default_modules.each do |mod|
      mod_class = Object.const_get("ConfigMan::Modules::#{mod}")
      final_config.merge!(mod_class.populate_defaults)
    end

    # Populate defaults from custom modules
    @custom_modules.each do |mod_class|
      final_config.merge!(mod_class.populate_defaults)
    end

    # Add custom options
    final_config.merge!(custom_options) unless custom_options.empty?

    # Write to the config file using the appropriate parser
    parser_module = Object.const_get("ConfigMan::Parsers::#{@loaded_parser.upcase}")
    parser_module.write(final_config)
  end

  # Generate a .config file in the working directory
  def self.generate_config_file(final_config)
    File.open('.config', 'w') do |file|
      case @loaded_parser
      when 'json'
        file.write(JSON.pretty_generate(final_config))
      when 'yaml'
        require 'yaml'
        file.write(final_config.to_yaml)
      when 'xml'
        require 'rexml/document'
        xml = REXML::Document.new
        xml.add_element('config', final_config)
        formatter = REXML::Formatters::Pretty.new
        formatter.write(xml, file)
      when 'ini'
        require 'inifile'
        ini = IniFile.new
        ini['default'] = final_config
        file.write(ini.to_s)
      else
        file.write(JSON.pretty_generate(final_config)) # Default to JSON
      end
    end
  end

  # Lazy loading of modules and parsers
  def self.load_modules(module_names)
    module_names.each do |module_name|
      if %w[json ini xml yaml].include?(module_name.downcase)
        # It's a parser
        require_relative "configman/parsers/#{module_name.downcase}"
        @loaded_parser = module_name.downcase
      else
        # It's a regular module
        require_relative "configman/modules/#{module_name.downcase}"
      end
      @used_modules << module_name.downcase
    end
  end

  # Cleanup unused modules
  def self.cleanup_unused_modules
    # List of all available modules
    all_modules = %w[database logging api ini yaml]

    # Calculate modules to remove
    remove_modules = all_modules - @used_modules

    # Remove unnecessary modules
    remove_modules.each do |mod|
      module_path = File.join(__dir__, 'modules', "#{mod}.rb")
      File.delete(module_path) if File.exist?(module_path)
    end
  end

  # Load configurations from the .config file
  def self.load
    config_file_path = File.join(Dir.pwd, '.config')
    parsed_config = send_to_parser(config_file_path)

    parsed_config.each do |module_name, config|
      define_singleton_method(module_name) do
        config
      end
    end
  end

  # Delegate to the appropriate parser to parse the file
  def self.send_to_parser(file_path)
    raise ArgumentError, 'No parser loaded' unless @loaded_parser

    parser_module = Object.const_get("ConfigMan::Parsers::#{@loaded_parser.upcase}")

    raise ArgumentError, "Invalid parser: #{@loaded_parser}" unless parser_module.respond_to?(:parse)

    parsed_config = parser_module.parse(file_path)
    @config_values.merge!(parsed_config)
  end

  def self.fetch(key)
    @config_values[key] || raise(%(Configuration key "#{key}" not found.))
  end

  # Handle undefined methods to fetch config values
  def self.method_missing(method_name, *args, &block)
    if @config_values.key?(method_name)
      @config_values[method_name]
    else
      super
    end
  end

  # Respond to missing methods
  def self.respond_to_missing?(method_name, include_private = false)
    @config_values.key?(method_name) || super
  end
end
