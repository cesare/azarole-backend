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
      let(:specified_recorded_at) { Time.current.yesterday.round }
      let(:attendance_record) { AttendanceRecord.create!(workplace:, event: "clock-in", recorded_at: specified_recorded_at) }

      subject { attendance_record.recorded_at }

      it { is_expected.to eq specified_recorded_at }
    end
  end

  describe "#clock_in?" do
    context "when event is clock-in" do
      subject { AttendanceRecord.new(event: "clock-in") }

      it { is_expected.to be_clock_in }
    end

    context "when event is not clock-in" do
      subject { AttendanceRecord.new(event: "clock-out") }

      it { is_expected.not_to be_clock_in }
    end
  end

  describe "#clock_out?" do
    context "when event is clock-out" do
      subject { AttendanceRecord.new(event: "clock-out") }

      it { is_expected.to be_clock_out }
    end

    context "when event is not clock-out" do
      subject { AttendanceRecord.new(event: "clock-in") }

      it { is_expected.not_to be_clock_out }
    end
  end

  describe "#date" do
    subject { AttendanceRecord.new(recorded_at: Time.zone.parse("2025-09-16 12:45:56")).date }

    it { is_expected.to eq Date.parse("2025-09-16") }
  end
end
