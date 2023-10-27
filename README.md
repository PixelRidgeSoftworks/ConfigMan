# ConfigMan Gem

ConfigMan is a Ruby gem designed to simplify the configuration management of your Ruby applications. It provides a modular approach, allowing you to easily manage different aspects of your application's configuration such as API, Cache, Database, Email, and more. You can even extend its functionality by registering your own custom modules.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Built-in Modules](#built-in-modules)
  - [Custom Modules](#custom-modules)
- [Wiki](#wiki)
- [Contributing](#contributing)
- [License](#license)

## Installation

To install the ConfigMan gem, run the following command:

```bash
gem install configman
```

Or add it to your Gemfile:

```bash
gem 'configman'
```

Then run `bundle install`.

## Usage

### Built-in Modules

ConfigMan comes with a variety of built-in modules to manage different aspects of your configuration. Here's a quick example:

```ruby
require 'configman'

default_modules = ['API', 'Cache', 'Database', 'Email', 'FileStorage', 'Localization', 'Logging', 'YAML']
ConfigMan.load_modules(default_modules)
ConfigMan.setup(default_modules)
ConfigMan.load
```

### Custom Modules

You can also register your own custom modules to extend the functionality of ConfigMan. Here's how:

```ruby
require 'configman'
# Register the custom module
ConfigMan.register_module('/path/to/your/custom_module.rb')

# Then proceed with the rest of the setup as usual
default_modules = ['API', 'Cache', 'Database', 'YAML']
ConfigMan.load_modules(default_modules)
ConfigMan.setup(default_modules)
```

## Wiki

For more detailed information and advanced usage, please refer to our [Wiki](https://git.pixelridgesoftworks.com/PixelRidge-Softworks/ConfigMan/wiki)).

## Contributing

Contributions are welcome! Fork the repository to your account on our Git server, make your changes, and submit a PR! We will review, and if we don't find any issues, we will merge the PR!

## License

This project is licensed under the PixelRidge-BEGPULSE License. See the [LICENSE](LICENSE) file for details.
