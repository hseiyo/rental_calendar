require 'active_record'

class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :tools do |t|
      t.integer :tooltype, null: false
      t.string :toolname, null: false
      t.boolean :validitem, null: false

      t.timestamps
    end

    create_table :users do |t|
      t.string :username, null: false

      t.timestamps
    end

    create_table :reservations do |t|
      t.belongs_to :tool, index: true, foreign_key: true, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.datetime :begin, index: true, null: false
      t.datetime :end, index: true, null: false

      t.timestamps
    end

  end
end
