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



# def reservedList( needdays , viewmonth)
def reservedList( needdays , viewyear , viewmonth)
        if not viewyear.is_a?(Numeric) or viewyear < Date.today.year then
          return "Error: viewyear is not invalid number"
        end

        if not viewyear.is_a?(Numeric) or not ( 1 <= viewmonth and viewmonth <= 12 ) then
          return "Error: viewmonth is not invalid number"
        end

	todaybegin = Date.new( viewyear , viewmonth , 1 )
	todayend = Date.new( viewyear , viewmonth , -1 )
        needend = todayend + needdays * 2 + 1
	nglist = {} # nglist is a hash of hash: nglist["m" + month]["d" + day] = reservedflag
        ngcalendar = []

        # set reserved flag to all date
	for cdate in todaybegin..needend do
                if not nglist.has_key?(("m" + cdate.month.to_s).to_sym) then
                  nglist[("m" + cdate.month.to_s).to_sym] = {}
                end

		nglist[("m" + cdate.month.to_s).to_sym][("d" + cdate.day.to_s).to_sym] = "notreserved" # not reserved yet
		if Calendar.where( "begin <= ? and ? <= end", cdate , cdate ).count > 0 then
			nglist[("m" + cdate.month.to_s).to_sym][("d" + cdate.day.to_s).to_sym] = "reserved" # already reserved 
		end
	end

        # set avalable/unavailable
	for cdate in todaybegin..todayend do
		sum = 0
                for ndate in cdate..(cdate + needdays * 2 + 1) do
                  if nglist[("m" + ndate.month.to_s).to_sym][("d" + ndate.day.to_s).to_sym] == "reserved"  then
		    sum += 1
                  end
		end
                if sum > 0 then
                  nglist[("m" + (ndate + needdays).month.to_s).to_sym][("d" + (ndate + needdays).day.to_s).to_sym] = "unavailable"
                else
                  nglist[("m" + (ndate + needdays).month.to_s).to_sym][("d" + (ndate + needdays).day.to_s).to_sym] = "available"
                end
	end

        wi=0 # week index
        ngcalendar[wi] = []
        i=0 # loop index
        while i != todaybegin.wday do
          ngcalendar[wi].push( { :date => "" , :class => ["undefined" , "unselected" ] } )
          i += 1
        end
	for cdate in todaybegin..todayend do
          if cdate.wday != 0 then
            ngcalendar[wi].push( { :date => cdate.day , :class => [ nglist[("m" + cdate.month.to_s).to_sym][("d" + cdate.day.to_s).to_sym] , "unselected" ] } )
          else
            wi += 1
            ngcalendar[wi] = []
            ngcalendar[wi].push( { :date => cdate.day , :class => [ nglist[("m" + cdate.month.to_s).to_sym][("d" + cdate.day.to_s).to_sym] , "unselected" ] } )
          end
	end
        while ngcalendar[wi].length != 7 do
          ngcalendar[wi].push( { :date => "" , :class => ["undefined" , "unselected" ] } )
        end
	return ngcalendar
end

get '/' do
	content = { :title => 'hello world' }
	json content
end

get '/abc' do
	# cal = Calendar.new
	# cal.begin = '2018/04/19 0:0:0'
	# cal.end = '2018/05/09 0:0:0'
	# cal.save

	# content = { :title => Calendar.where( :begin >= '2018-05-01' and :end < '2018-04-01' ) }
	# content = { :title => reservedList(3 , 1) }
        needdays = params['days'].to_i
	content = reservedList(needdays , 2018 , 5) # need days, yesr , month
	
	json content
end


#get '/calendar' do
#	content = { :title => 'calendar' }
#	content = [ { :year => '2018' , :month => '2' ,:day => '1' , :reserved => 'yes' } , { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' }, { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' } ]
#	json content
#end

get '/rencal/*' do |month|
	content = [ { :date => "#{month}" , :reserved => 'yes' } , { :date => "#{month}" , :reserved => 'yes' } ,{ :date => "#{month}" , :reserved => 'yes' } ]
	json content
end


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
