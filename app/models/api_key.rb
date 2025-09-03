class ApiKey < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :digest, presence: true

  class << self
    def generate_new_api_key(user:, name:)
      token = TokenGenerator.new.generate
      digest = TokenDigester.new(token:).digest
      api_key = create!(user:, name:, digest:)

      {api_key:, raw_token: token}
    end
  end
end
