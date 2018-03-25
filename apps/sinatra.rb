#!/home/ubuntu/.rbenv/shims/ruby

#$LOAD_PATH.unshift '/home/ubuntu/work/rental_calendar/ruby/2.4.0/gems'
#$LOAD_PATH.unshift '/home/ubuntu/.rbenv/versions/2.4.0'
#$LOAD_PATH.unshift '/home/ubuntu/.rbenv/versions/2.4.0/lib'
# $LOAD_PATH.unshift '/home/ubuntu/.rbenv//ruby/2.4.0/gems'
#ENV['GEM_HOME'] = '/home/ubuntu/work/rental_calendar/ruby/2.4.0/gems'


#require 'rubygems'
require 'sinatra'
require 'sinatra/json'
#require 'rack'

get '/' do
	content = { :title => 'hello world' }
	json content
end

#get '/calendar' do
#	content = { :title => 'calendar' }
#	content = [ { :year => '2018' , :month => '2' ,:day => '1' , :reserved => 'yes' } , { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' }, { :year => '2018' , :month => '1' ,:day => '2' , :reserved => 'yes' } ]
#	json content
#end

get '/calendar/*' do |month|
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
