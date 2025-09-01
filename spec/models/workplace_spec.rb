require "rails_helper"

RSpec.describe Workplace, type: :model do
  describe "validations" do
    let(:user) { User.create }

    context "when name is not given" do
      subject { Workplace.new(user: user) }

      it { is_expected.not_to be_valid }
    end

    context "when name is given" do
      subject { Workplace.new(user: user, name: "Home") }

      it { is_expected.to be_valid }
    end
  end
end
