#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"

require "active_record"

require "logger"
# logger = Logger.new(STDERR) # to httpd's error.log

# load database.yml
include ActiveRecord::Tasks
config_dir = File.expand_path("../config", __dir__)
DatabaseTasks.env = ENV["APP_ENV"] || "development"
DatabaseTasks.database_configuration = YAML.safe_load(File.open(File.join(config_dir, "database.yml")))
ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym

# User as:
# id
# user_name
class User < ActiveRecord::Base
  has_many :reservations
end

# Tool has
# id
# tool_type
# tool_name
class Tool < ActiveRecord::Base
  has_many :reservations
  validates :tooltype, presence: true, numericality: { only_integer: true }
  validates :toolname, presence: true, uniqueness: true
  validates :toolvalid, presence: true

  class << self
    def make_sample_tool
      Tool.delete_all
      Tool.create(tooltype: 1, toolid: 1, name: "\u57FA\u672C\u30BB\u30C3\u30C8\uFF11")
      Tool.create(tooltype: 1, toolid: 2, name: "\u57FA\u672C\u30BB\u30C3\u30C8\uFF12")
      Tool.create(tooltype: 1, toolid: 3, name: "\u57FA\u672C\u30BB\u30C3\u30C8\uFF13")
      Tool.create(tooltype: 2, toolid: 1, name: "\u5FDC\u7528\u30BB\u30C3\u30C8\uFF11")
      Tool.create(tooltype: 2, toolid: 2, name: "\u5FDC\u7528\u30BB\u30C3\u30C8\uFF12")
      true
    end
  end
end

# Reservation has:
# id
# user_id
# tool_id
# begin
# end
class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :tool

  class << self
    def month_list(date_info)
      month_list = []
      logger = Logger.new(STDERR) # to httpd's error.log
      logger.info "in month_list #{date_info}"
      (date_info[:begindate]..date_info[:finishdate]).each do |cdate|
        # for cdate in date_info[:begindate ]..date_info [ :finishdate ] do
        wherebegin = cdate + date_info[:needdays]
        whereend = cdate - date_info[:needdays] - 1
        # logger.info Reservation.joins(:tool)
        # .where("reservations.begin <= ? and ? <= reservations.finish", wherebegin, whereend)
        # .where(tools: { tooltype: date_info[:toolop] })
        # .to_sql
        if Reservation.joins(:tool)\
                      .where("reservations.begin <= ? and ? <= reservations.finish", wherebegin, whereend)\
                      .where(tools: { tooltype: date_info[:toolop] })\
                      .count.positive?
          month_list.push(day: cdate,
                          date: cdate.day,
                          available: false,
                          calendar_text: "\u00D7",
                          class: %w[unavailable unselect])
        else
          month_list.push(day: cdate,
                          date: cdate.day,
                          available: true,
                          calendar_text: "\u3007",
                          class: %w[available unselect])
        end
      end
      month_list
    end

    def get_calendar_array(calendar_array)
      ngcalendar = []

      wi = 0 # week index
      ngcalendar[wi] = []
      i = 0 # loop index

      # first week loop before first date
      while i != calendar_array.first[:day].wday
        ngcalendar[wi].push(date: "", class: %w[undefined unselected], calendar_text: "\u00D7")
        i += 1
      end

      calendar_array.each do |cdate|
        if cdate[:day].wday.zero?
          wi += 1
          ngcalendar[wi] = []
        end
        ngcalendar[wi].push(cdate)
      end

      # last week loop after last date
      while ngcalendar[wi].length != 7
        ngcalendar[wi].push(date: "", class: %w[undefined unselected], calendar_text: "\u00D7")
      end
      ngcalendar
    end
  end
end

# Order class
class Order
  class << self
    def create(user_info, reservation_info)
      order = nil
      ActiveRecord::Base.transaction do
        # oUser model is treat as order
        order = User.create(user_info)

        reservation_info.each do |r|
          a = Reservation.create(r.merge(user_id: order.id))
        end
      end
      return order
      resque StandardException => e
      raise
    end
  end
end

# Calendar class
class Calendar
  class << self
    def make_reserve(rsv_info)
      # TODO: add user,phone,address, etc
      use_date = Date.new(rsv_info[:year], rsv_info[:month], rsv_info[:day])

      # need transaction
      current_user = User.create(username: rsv_info[:username])
      # need to add validation check column in where
      logger.info rsv_info

      # TODO: not is not needed?
      available_tool_id = Tool.left_outer_joins(:reservations)\
                              .where("tools.tooltype = ?", rsv_info[:tooltype])\
                              .where.not(id: Reservation\
        .where("finish <= ? or ? <= begin or finish is null", \
               use_date - rsv_info[:needdays],\
               use_date + rsv_info[:needdays] + 1)\
                              .pluck(:tool_id))\
                              .pluck(:id).first
      #     logger.info "SQL is "
      #     logger.info Tool.left_outer_joins(:reservations)\
      #       .where("tools.tooltype = ?", rsv_info[:tooltype])\
      #                     .where(id: Reservation\
      #       .where("finish <= ? or ? <= begin or finish is null", \
      #              use_date - rsv_info[:needdays],\
      #              use_date + rsv_info[:needdays] + 1)\
      #                             .pluck(:tool_id))\
      #                     .to_sql
      #
      #     logger.info "Ignorable reservation: " # TODO: Really?
      #     logger.info Reservation.where("finish <= ? or ? <= begin or finish is null", \
      #                                   use_date - rsv_info[:needdays],\
      #                                   use_date + rsv_info[:needdays] + 1)\
      #                            .pluck(:id, :tool_id)
      #
      current_reservation = Reservation.create(tool_id: available_tool_id, user_id: current_user.id,\
                                               begin: use_date - rsv_info[:needdays],\
                                               finish: use_date + rsv_info[:needdays] + 1)
    end

    def get_date_info(dinfo)
      date_info = nil
      return date_info unless dinfo[:year].is_a?(Numeric) && (dinfo[:year] >= Date.today.year)

      return date_info unless dinfo[:month].is_a?(Numeric) && (dinfo[:month] >= 1) && (dinfo[:month] <= 12)

      # logger = Logger.new(STDERR) # to httpd's error.log
      # logger.info dinfo
      date_info = { needdays: dinfo[:needdays] }
      todaybegin = Date.new(dinfo[:year], dinfo[:month], 1)
      todayend = Date.new(dinfo[:year], dinfo[:month], -1)
      date_info[:begindate] = todaybegin
      date_info[:finishdate] = todayend
      date_info[:toolop] = dinfo[:toolop]
      date_info
    end
  end
end
