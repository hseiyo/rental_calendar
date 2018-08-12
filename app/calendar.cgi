#!/usr/bin/env ruby
# frozen_string_literal: true

load "calendar_rest.rb"

set :run, false
# set :environment, :cgi

Rack::Handler::CGI.run Sinatra::Application
