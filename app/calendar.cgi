#!/usr/bin/env ruby

load 'sinatra.rb'

set :run, false
#set :environment, :cgi

Rack::Handler::CGI.run Sinatra::Application

