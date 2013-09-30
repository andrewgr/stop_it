# Stop It

Stop It is a middleware for blocking requests to rake apps.

## Installation

Add this line to your application's Gemfile:

    gem 'stop_it'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stop_it

## Usage

Let's see how to use Stop It with Ruby on Rails apps. To insert Stop It into the stack of middlewares of your app open config.ru file and add line

    use StopIt

right after line

    require ::File.expand_path('../config/environment',  __FILE__)

so that the file contains code similar to this:

    # This file is used by Rack-based servers to start the application.

    require ::File.expand_path('../config/environment',  __FILE__)
    use StopIt
    run MyRailsApp::Application # Here should be your application class name

To configure which requests should be stopped add config/initializers/stop_it.rb file to your Ruby on Rails app with the following content:

    StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|

    end

If the block in stop method returns true then the request will be blocked. If it returns false then the request will be passed to the next middleware. In the following example all requests to /forbidden will be blocked.

    StopIt.stop do |path_info, remote_addr, query_string, request_method, user_agent|
      path_info == "/forbidden"
    end

## Contributing

Your contribution is welcome.
