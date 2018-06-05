#!/usr/bin/env ruby

#$LOAD_PATH.unshift '/home/ubuntu/work/rental_calendar/ruby/2.4.0/gems'
#$LOAD_PATH.unshift '/home/ubuntu/.rbenv/versions/2.4.0'
#$LOAD_PATH.unshift '/home/ubuntu/.rbenv/versions/2.4.0/lib'
# $LOAD_PATH.unshift '/home/ubuntu/.rbenv//ruby/2.4.0/gems'
#ENV['GEM_HOME'] = '/home/ubuntu/work/rental_calendar/ruby/2.4.0/gems'


#require 'rubygems'
require 'sinatra'
require 'sinatra/json'
#require 'rack'
require 'date'

require 'active_record'

# load database.yml
include ActiveRecord::Tasks
config_dir = File.expand_path('../../config', __FILE__)
DatabaseTasks.env = ENV['APP_ENV'] || 'development'
DatabaseTasks.database_configuration = YAML::load(File.open(File.join(config_dir, 'database.yml')))
ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym



class Calendar < ActiveRecord::Base
end

class Tool < ActiveRecord::Base
  validates :toolid, presence: true, numericality: { only_integer: true }
  validates :tooltype, presence: true, numericality: { only_integer: true }
  validates :name, presence: true, uniqueness: true

  # has_many :toolRentals
end

def makeReserve( year , month , day , area )
  useDate = Date.new( year, month, day )

  # need transaction
  if Calendar.where( "begin <= ? and ? <= end", useDate - area , useDate + area + 1 ).count > 0 then
    # already reserved by someone else
    return
  end

  nr = Calendar.create( :begin => useDate - area, :end => useDate + area + 1 )
end


def reservedList( needdays , viewyear , viewmonth)
  if not viewyear.is_a?(Numeric) or viewyear < Date.today.year then
    return "Error: viewyear is not invalid number"
  end

  if not viewyear.is_a?(Numeric) or not ( 1 <= viewmonth and viewmonth <= 12 ) then
    return "Error: viewmonth is not invalid number"
  end

  todaybegin = Date.new( viewyear , viewmonth , 1 )
  todayend = Date.new( viewyear , viewmonth , -1 )
  ngcalendar = []

  wi=0 # week index
  ngcalendar[wi] = []
  i=0 # loop index
  while i != todaybegin.wday do
    ngcalendar[wi].push( { :date => "" , :class => ["undefined" , "unselected" ], :calendarText => "×" } )
    i += 1
  end
  for cdate in todaybegin..todayend do
    #if nglist[("m" + cdate.month.to_s).to_sym][("d" + cdate.day.to_s).to_sym] == "available" then
    wherebegin =  cdate + needdays
    whereend = cdate - needdays - 1
    available = "unavailable"
    if Calendar.where( "begin <= ? and ? <= end",  wherebegin, whereend ).count > 0 then
      calendarText = "×"
    else
      calendarText = "〇"
      available = "available"
    end

    if cdate.wday == 0 then
      wi += 1
      ngcalendar[wi] = []
    end
    ngcalendar[wi].push( { :date => cdate.day , :class => [ available , "unselected" ] , :calendarText => calendarText } )

  end
  while ngcalendar[wi].length != 7 do
    ngcalendar[wi].push( { :date => "" , :class => ["undefined" , "unselected" ], :calendarText => "×" } )
  end
  return ngcalendar
end

def makeSampleTool()
  Tool.delete_all
  Tool.create( :tooltype => 1,:toolid => 1 , :name => "基本セット１" )
  Tool.create( :tooltype => 1,:toolid => 2 , :name => "基本セット２" )
  Tool.create( :tooltype => 1,:toolid => 3 , :name => "基本セット３" )
  Tool.create( :tooltype => 2,:toolid => 1 , :name => "応用セット１" )
  Tool.create( :tooltype => 2,:toolid => 2 , :name => "応用セット２" )
  return true
end


def getToolsList()
  return Tool.all
end

# / menas /rencal/calendar/
get '/' do
  content = { :title => 'hello world' }
  json content
end

get '/admin/tools' do
  # content = {}
  # content[:tools] = getToolsList()
  json getToolsList()
end

# add new tool
post '/admin/tools' do
  tool = Tool.new
  params = JSON.parse request.body.read
  tool.tooltype = params['tooltype']
  tool.toolid = Tool.where( "tooltype = ?",tool.tooltype ).maximum(:toolid)
  tool.toolid = tool.toolid.nil? ? 1 : tool.toolid + 1
  tool.name = params['name']
  tool.save
 
  json tool
end


# modify tool property
put '/admin/tools/:id' do
  tool = Tool.find_by( id: params['id'] )
  
  params = JSON.parse request.body.read
  tool.tooltype = params['tooltype']
  tool.toolid = params['toolid']
  tool.name = params['name']
  tool.save
 
  json params
end

# delete a tool
delete '/admin/tools/:id' do
  tool = Tool.find_by( id: params['id'] )
  tool.destroy
  # tool.save
 
  json tool
end



get '/admin/areas' do
  content = {}
  content[:tools] = getToolsList()
  json content
end

get '/admin' do
  # year = params['year'].to_i
  # month = params['month'].to_i
  # day = params['day'].to_i
  # needdays = params['days'].to_i

  content = {}
  content[:tools] = getToolsList()
  json content
end


get '/rencal' do
  year = params['year'].to_i
  month = params['month'].to_i
  day = params['day'].to_i
  needdays = params['days'].to_i

  content = reservedList(needdays , year , month) # need days, yesr , month
  json content
end

post '/rencal' do
  year = params['year'].to_i
  month = params['month'].to_i
  day = params['day'].to_i
  needdays = params['days'].to_i

  makeReserve( year, month, day , needdays);

  content = reservedList(needdays , year , month) # need days, yesr , month
  json content
end



#get '/calendar' do
#  content = { :title => 'calendar' }
#  content = [ { :year => '2018' , :month => '2' ,:day => '1' , :reserved => 'yes' } , { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' }, { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' } ]
#  json content
#end

# get '/rencal/*' do |month|
#   content = [ { :date => "#{month}" , :reserved => 'yes' } , { :date => "#{month}" , :reserved => 'yes' } ,{ :date => "#{month}" , :reserved => 'yes' } ]
#   json content
# end



post '/' do
  #content = { 'reserve:yes', 'email:mail@example.com' , { 'year:2018' , 'month:1' ,'day:1' } , { 'year:2018' , 'month:1' ,'day:2' }, { 'year:2018' , 'month:1' ,'day:2' }}
  # #.. create something #..
end

put '/' do
  #.. replace something #..
end

patch '/' do
  #.. modify something #..
end

delete '/' do
  #.. annihilate something #..
end

options '/' do
  #.. appease something #..
end

link '/' do
  #.. affiliate something #..
end

unlink '/' do
  #.. separate something #..
end
