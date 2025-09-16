require "rails_helper"

RSpec.describe WorkingTime do
  describe "initialization" do
    context "with clock-in attendance_record" do
      let(:clock_in) { AttendanceRecord.new(event: "clock-in", recorded_at: Time.current.yesterday) }

      subject(:working_time) { WorkingTime.new(attendance_record: clock_in) }

      it "builds new object" do
        expect(working_time.clock_in).to eq clock_in
        expect(working_time.clock_out).to be_blank
      end
    end

    context "with clock-out attendance_record" do
      let(:clock_out) { AttendanceRecord.new(event: "clock-out", recorded_at: Time.current.yesterday) }

      subject(:working_time) { WorkingTime.new(attendance_record: clock_out) }

      it "builds new object" do
        expect(working_time.clock_in).to be_blank
        expect(working_time.clock_out).to eq clock_out
      end
    end
  end

  describe "#clock_in=" do
    let(:clock_in) { AttendanceRecord.new(event: "clock-in", recorded_at: Time.current.change(hour: 13)) }
    let(:clock_out) { AttendanceRecord.new(event: "clock-out", recorded_at: Time.current.change(hour: 17)) }

    subject(:working_time) { WorkingTime.new(attendance_record: clock_out) }

    it "sets clock_in" do
      expect {
        working_time.clock_in = clock_in
      }.to change(working_time, :clock_in).to(clock_in)
        .and not_change(working_time, :clock_out).from(clock_out)
    end
  end

  describe "#clock_out=" do
    let(:clock_in) { AttendanceRecord.new(event: "clock-in", recorded_at: Time.current.change(hour: 13)) }
    let(:clock_out) { AttendanceRecord.new(event: "clock-out", recorded_at: Time.current.change(hour: 17)) }

    subject(:working_time) { WorkingTime.new(attendance_record: clock_in) }

    it "sets clock_out" do
      expect {
        working_time.clock_out = clock_out
      }.to not_change(working_time, :clock_in).from(clock_in)
        .and change(working_time, :clock_out).to(clock_out)
    end
  end
end
