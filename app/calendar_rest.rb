#!/usr/bin/env ruby
# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
# require 'rack'
require "date"

require "logger"
# logger = Logger.new(STDERR) # to httpd's error.log

# calendar requires Tool, User, Reservation classes
require_relative "models/calendar"

############## URI
# / means /rencal/calendar/
#
##### for administrator
# get "/admin/:class/?"
# # add new tool
# post "/admin/:class/?"
# # modify tool property
# put "/admin/:class/:id"
# # delete a tool
# delete "/admin/:class/:id"
# get "/admin/areas"
# get "/admin"
#

##### for public users
# / means /rencal/calendar/
# get "/"
# get "/rencal"
# post "/rencal"
#
### not implemented
# post "/"
# put "/"
# patch "/"
# delete "/"
# options "/"
# link "/"
# unlink "/"

# / means /rencal/calendar/
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

## for publich user
# / means /rencal/calendar/
get "/" do
  content = { title: "hello world" }
  json content
end

get "/rencal" do
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
  reserve_info[:toolop].push(1) if params[:toolop1] == "true"
  reserve_info[:toolop].push(2) if params[:toolop2] == "true"
  reserve_info[:toolop].push(3) if params[:toolop3] == "true"

  # logger = Logger.new(STDERR) # to httpd's error.log
  # date_info = Calendar.get_date_info(needdays, year, month) # need days, yesr , month
  # logger.info "in get /rencal #{reserve_info}"
  date_info = Calendar.get_date_info(reserve_info) # need days, yesr , month
  # logger.info "in get /rencal #{date_info}"
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

  content = Reservation.reserved_list(reserve_info[:needdays],
                                      reserve_info[:year],
                                      reserve_info[:month]) # need days, yesr , month
  json content
end

error do
  env["sinatra.error"].message
end
