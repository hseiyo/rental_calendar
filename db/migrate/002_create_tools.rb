require 'active_record'

class CreateTools < ActiveRecord::Migration[4.2]
  def self.up
    create_table :tools do |t|
      t.integer :tooltype
      t.integer :toolid
      t.string :name
      t.boolean :valid

      t.timestamps
    end

    add_index :tools, [:tooltype ]
  end

  def self.down
    drop_table :tools
  end
end
