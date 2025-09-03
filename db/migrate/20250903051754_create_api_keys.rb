class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.string :digest, null: false, index: {unique: true}
      t.datetime :created_at, precision: 6, null: false
    end
  end
end
