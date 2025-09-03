class ApiKey < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :digest, presence: true
end
