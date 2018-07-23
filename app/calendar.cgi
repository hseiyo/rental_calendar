#!/usr/bin/env ruby

load 'calendar_rest.rb'

set :run, false
#set :environment, :cgi

Rack::Handler::CGI.run Sinatra::Application

