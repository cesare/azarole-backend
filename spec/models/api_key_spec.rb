require "rails_helper"

RSpec.describe ApiKey, type: :model do
  describe "validations" do
    let(:user) { User.create! }

    context "when name is not given" do
      subject { ApiKey.new(user:, digest: "digest") }

      it { is_expected.not_to be_valid }
    end

    context "when name is not given" do
      subject { ApiKey.new(user:, name: "for test", digest: "digest") }

      it { is_expected.to be_valid }
    end

    context "when digest is not given" do
      subject { ApiKey.new(user:, name: "test") }

      it { is_expected.not_to be_valid }
    end

    context "when digest is not given" do
      subject { ApiKey.new(user:, name: "test", digest: "digest") }

      it { is_expected.to be_valid }
    end
  end
end
