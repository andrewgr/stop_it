# Stop It

[![Build Status](https://travis-ci.org/andrewgr/stop_it.png)](https://travis-ci.org/andrewgr/stop_it)
[![Code Climate](https://codeclimate.com/github/andrewgr/stop_it/badges/gpa.svg)](https://codeclimate.com/github/andrewgr/stop_it)
[![Test Coverage](https://codeclimate.com/github/andrewgr/stop_it/badges/coverage.svg)](https://codeclimate.com/github/andrewgr/stop_it/coverage)

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

    StopIt.stop do |opts|

    end

`opts` is a hash with the following keys: `path_info`, `remote_addr`, `query_string`, `request_method`, `http_user_agent`.

If the block in stop method returns true then the request will be blocked. If it returns false then the request will be passed to the next middleware. In the following example all requests to /forbidden will be blocked.

    StopIt.stop do |opts|
      opts[:path_info] == '/forbidden'
    end

Requests can be blocked by request path, remote address, query string, HTTP method, and user agent.

The block in stop method may return a rake app response like this:

    StopIt.stop do |opts|
      if opts[:remote_addr] == '127.0.0.2'
        [403, { 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
      end
    end

In this case the request will be blocked and the requestor will receive the returned response.

## Contributing

Your contribution is welcome.
