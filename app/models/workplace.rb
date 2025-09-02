class Workplace < ApplicationRecord
  belongs_to :user
  has_many :attendance_records

  validates :name, presence: true
end
