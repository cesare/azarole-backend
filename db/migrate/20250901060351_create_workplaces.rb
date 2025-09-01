class CreateWorkplaces < ActiveRecord::Migration[8.0]
  def change
    create_table :workplaces do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
