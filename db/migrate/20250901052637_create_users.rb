class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.datetime "created_at", precision: 6, null: false
    end
  end
end
