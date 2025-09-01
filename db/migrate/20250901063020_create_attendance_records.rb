class CreateAttendanceRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_records do |t|
      t.references :workplace, null: false
      t.string :event, null: false
      t.datetime :recorded_at, null: false
      t.datetime :created_at, precision: 6, null: false
    end
  end
end
