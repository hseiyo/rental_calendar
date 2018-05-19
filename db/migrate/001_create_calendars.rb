require 'active_record'

class CreateCalendars < ActiveRecord::Migration[4.2]
  def self.up
    create_table :calendars do |t|
      t.datetime :begin
      t.datetime :end

      t.timestamps
    end

    add_index :calendars, [:begin, :end]
  end

  def self.down
    drop_table :calendars
  end
end
