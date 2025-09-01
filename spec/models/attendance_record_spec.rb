require "rails_helper"

RSpec.describe AttendanceRecord, type: :model do
  context "validations" do
    let(:user) { User.create }
    let(:workplace) { Workplace.create(user: user, name: "Home") }

    context "when event is not given" do
      subject { AttendanceRecord.new(workplace:) }

      it { is_expected.not_to be_valid }
    end

    context "when event is given" do
      subject { AttendanceRecord.new(workplace:, event: "clock-in") }

      it { is_expected.to be_valid }
    end
  end

  context "recorded_at" do
    let(:user) { User.create }
    let(:workplace) { Workplace.create(user: user, name: "Home") }

    context "when recorded_at is not given" do
      let(:attendance_record) { AttendanceRecord.create!(workplace:, event: "clock-in") }

      subject { attendance_record.recorded_at }

      it { is_expected.to be_present }
    end

    context "when recorded_at is given" do
      let(:specified_recorded_at) { Time.current.yesterday }
      let(:attendance_record) { AttendanceRecord.create!(workplace:, event: "clock-in", recorded_at: specified_recorded_at) }

      subject { attendance_record.recorded_at }

      it { is_expected.to eq specified_recorded_at }
    end
  end
end
