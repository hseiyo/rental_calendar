#!/usr/bin/env ruby
# frozen_string_literal: true

# $LOAD_PATH.unshift '/home/ubuntu/work/rental_calendar/ruby/2.4.0/gems'
# $LOAD_PATH.unshift '/home/ubuntu/.rbenv/versions/2.4.0'
# $LOAD_PATH.unshift '/home/ubuntu/.rbenv/versions/2.4.0/lib'
# $LOAD_PATH.unshift '/home/ubuntu/.rbenv//ruby/2.4.0/gems'
# ENV['GEM_HOME'] = '/home/ubuntu/work/rental_calendar/ruby/2.4.0/gems'

# require 'rubygems'
require "sinatra"
require "sinatra/json"
# require 'rack'
require "date"

# require "active_record"

require "logger"
# logger = Logger.new(STDERR) # to httpd's error.log

# calendar includes Tool, User, Reservation classes
require_relative "calendar"

# / means /rencal/calendar/
get "/" do
  content = { title: "hello world" }
  json content
end

get "/admin/:class/?" do
  case params["class"]
  when "tools"
    json Tool.all
  when "reservations"
    json Reservation.all
  when "users"
    json User.all
  else
    json nil
  end
end

# add new tool
post "/admin/:class/?" do
  case params["class"]
  when "tools"
    item = Tool.new
    params = JSON.parse request.body.read
    item.tooltype = params["tooltype"]
    item.toolname = params["toolname"]
    item.toolvalid = params["toolvalid"]
    item.save
    item.reload
    json item

  when "reservations"
    item = Reservation.new
    params = JSON.parse request.body.read
    item.tool_id = params["toolid"]
    item.user_id = params["userid"]
    item.begin = Date.parse(params["begin"])
    item.finish = Date.parse(params["finish"])
    item.save
    item.reload

    json item

  when "users"
    item = User.new
    params = JSON.parse request.body.read
    item.username = params["username"]
    item.save
    item.reload

    json item

  else
    json nil
  end
end

# modify tool property
put "/admin/:class/:id" do
  item = nil

  case params["class"]
  when "tools"
    item = Tool.find_by(id: params["id"])

    params = JSON.parse request.body.read
    item.tooltype = params["tooltype"]
    item.toolname = params["toolname"]
    item.toolvalid = params["toolvalid"]
    item.save
    item.reload

  when "reservation"
    item = Reservation.find_by(id: params["id"])

    params = JSON.parse request.body.read
    item.userid = params["user_id"]
    item.toolid = params["tool_id"]
    item.begin = Date.parse(params["begin"])
    item.finish = Date.parse(params["finish"])
    item.save
    item.reload

  when
    item = User.find_by(id: params["id"])
    params = JSON.parse request.body.read
    item.username = params["username"]

  else
    # ??? some error
    item = nil
  end

  json item
end

# delete a tool
delete "/admin/:class/:id" do
  case params["class"]
  when "tools"
    item = Tool.find_by(id: params["id"])
    item.destroy

  when "reservations"
    item = Reservation.find_by(id: params["id"])
    item.destroy

  when "users"
    item = User.find_by(id: params["id"])
    item.destroy
  else
    item = nil
  end

  json item
end

get "/admin/areas" do
  content = {}
  content[:tools] = Tool.all
  json content
end

get "/admin" do
  content = {}
  content[:tools] = Tool.all
  json content
end

# for publich user
get "/rencal" do
  # year = params["year"].to_i
  # month = params["month"].to_i
  # # day = params["day"].to_i
  # needdays = params["days"].to_i

  reserve_info = {}
  reserve_info[:year] = params["year"].to_i
  reserve_info[:month] = params["month"].to_i
  reserve_info[:day] = params["day"].to_i
  reserve_info[:needdays] = params["days"].to_i
  reserve_info[:tooltype] = params["tooltype"].to_i
  reserve_info[:username] = params["username"]
  reserve_info[:phone] = params["phone"]
  reserve_info[:email] = params["email"]
  reserve_info[:address] = params["address"]
  reserve_info[:toolop] = []
  reserve_info[:toolop].push(params["toolop1"]) if params.key?(:toolop1)
  reserve_info[:toolop].push(params["toolop2"]) if params.key?(:toolop2)
  reserve_info[:toolop].push(params["toolop3"]) if params.key?(:toolop3)

  # date_info = Calendar.get_date_info(needdays, year, month) # need days, yesr , month
  date_info = Calendar.get_date_info(reserve_info) # need days, yesr , month
  content = Reservation.get_calendar_array(Reservation.month_list(date_info))
  json content
end

post "/rencal" do
  params = JSON.parse request.body.read
  reserve_info = {}
  reserve_info[:year] = params["year"].to_i
  reserve_info[:month] = params["month"].to_i
  reserve_info[:day] = params["day"].to_i
  reserve_info[:needdays] = params["days"].to_i
  reserve_info[:tooltype] = params["tooltype"].to_i
  reserve_info[:username] = params["username"]
  reserve_info[:phone] = params["phone"]
  reserve_info[:email] = params["email"]
  reserve_info[:address] = params["address"]
  reserve_info[:toolop] = []
  reserve_info[:toolop].push(params["toolop1"]) if params.key?(:toolop1)
  reserve_info[:toolop].push(params["toolop2"]) if params.key?(:toolop2)
  reserve_info[:toolop].push(params["toolop3"]) if params.key?(:toolop3)

  make_reserve(reserve_info)

  content = Reservation.reserved_list(reserve_info[:needdays], reserve_info[:year], reserve_info[:month]) # need days, yesr , month
  json content
end

# get '/calendar' do
#  content = { :title => 'calendar' }
#  content = [ { :year => '2018' , :month => '2' ,:day => '1' , :reserved => 'yes' } , { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' }, { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' } ]
#  json content
# end

# get '/rencal/*' do |month|
#   content = [ { :date => "#{month}" , :reserved => 'yes' } , { :date => "#{month}" , :reserved => 'yes' } ,{ :date => "#{month}" , :reserved => 'yes' } ]
#   json content
# end

post "/" do
  # content = { 'reserve:yes', 'email:mail@example.com' , { 'year:2018' , 'month:1' ,'day:1' } , { 'year:2018' , 'month:1' ,'day:2' }, { 'year:2018' , 'month:1' ,'day:2' }}
  # #.. create something #..
end

put "/" do
  # .. replace something #..
end

patch "/" do
  # .. modify something #..
end

delete "/" do
  # .. annihilate something #..
end

options "/" do
  # .. appease something #..
end

link "/" do
  # .. affiliate something #..
end

unlink "/" do
  # .. separate something #..
end
