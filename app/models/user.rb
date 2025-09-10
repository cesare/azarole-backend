class User < ApplicationRecord
  has_many :api_keys
  has_many :workplaces
end
