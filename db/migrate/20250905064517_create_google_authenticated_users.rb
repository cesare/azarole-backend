class CreateGoogleAuthenticatedUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :google_authenticated_users do |t|
      t.references :user, null: false
      t.string :uid, null: false, index: {unique: true}
      t.datetime :created_at, precision: 6, null: false
    end
  end
end
