require 'active_record'

class CreateTools < ActiveRecord::Migration[4.2]
  def self.up
    create_table :tools do |t|
      t.integer :toolid
      t.integer :tooltype
      t.string :name
      t.datetime :begin
      t.datetime :end

      t.timestamps
    end

    add_index :tools, [:toolid, :begin, :end]
  end

  def self.down
    drop_table :tools
  end
end
