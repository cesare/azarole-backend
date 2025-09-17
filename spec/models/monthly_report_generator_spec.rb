require "rails_helper"

RSpec.describe MonthlyReportGenerator do
  describe "#generate" do
    let(:user) { User.create! }
    let(:workplace) { user.workplaces.create!(name: "Home") }

    context "when no attendance recorded in the month" do
      let(:generator) { MonthlyReportGenerator.new(workplace:, year: 2025, month: 9) }

      subject { generator.generate }

      it { is_expected.to be_empty }
    end

    context "when a complete attendance pair recorded" do
      let(:generator) { MonthlyReportGenerator.new(workplace:, year: 2025, month: 9) }

      before do
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 12:34:56"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-01 17:00:00"))
      end

      subject(:result) { generator.generate }

      it "generates working_times grouped by date" do
        date_0901 = Date.parse("2025-09-01")
        expect(result.keys).to eq [date_0901]

        working_times_0901 = result[date_0901]
        expect(working_times_0901.length).to eq 1
        expect(working_times_0901[0].clock_in.recorded_at).to eq Time.zone.parse("2025-09-01 12:34:56")
        expect(working_times_0901[0].clock_out.recorded_at).to eq Time.zone.parse("2025-09-01 17:00:00")
      end
    end

    context "when complete attendance pairs recorded" do
      let(:generator) { MonthlyReportGenerator.new(workplace:, year: 2025, month: 9) }

      before do
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 12:34:56"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-01 17:00:00"))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-30 15:01:02"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-30 18:11:22"))
      end

      subject(:result) { generator.generate }

      it "generates working_times grouped by date" do
        date_0901 = Date.parse("2025-09-01")
        date_0930 = Date.parse("2025-09-30")
        expect(result.keys).to eq [date_0901, date_0930]

        working_times_0901 = result[date_0901]
        expect(working_times_0901.length).to eq 1
        expect(working_times_0901[0].clock_in.recorded_at).to eq Time.zone.parse("2025-09-01 12:34:56")
        expect(working_times_0901[0].clock_out.recorded_at).to eq Time.zone.parse("2025-09-01 17:00:00")

        working_times_0902 = result[date_0930]
        expect(working_times_0902.length).to eq 1
        expect(working_times_0902[0].clock_in.recorded_at).to eq Time.zone.parse("2025-09-30 15:01:02")
        expect(working_times_0902[0].clock_out.recorded_at).to eq Time.zone.parse("2025-09-30 18:11:22")
      end
    end

    context "when multiple complete attendance pairs for a day recorded" do
      let(:generator) { MonthlyReportGenerator.new(workplace:, year: 2025, month: 9) }

      before do
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 10:00:01"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-01 11:30:00"))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 12:34:56"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-01 17:00:00"))
      end

      subject(:result) { generator.generate }

      it "generates working_times grouped by date" do
        date_0901 = Date.parse("2025-09-01")
        expect(result.keys).to eq [date_0901]

        working_times_0901 = result[date_0901]
        expect(working_times_0901.length).to eq 2
        expect(working_times_0901[0].clock_in.recorded_at).to eq Time.zone.parse("2025-09-01 10:00:01")
        expect(working_times_0901[0].clock_out.recorded_at).to eq Time.zone.parse("2025-09-01 11:30:00")
        expect(working_times_0901[1].clock_in.recorded_at).to eq Time.zone.parse("2025-09-01 12:34:56")
        expect(working_times_0901[1].clock_out.recorded_at).to eq Time.zone.parse("2025-09-01 17:00:00")
      end
    end

    context "when incomplete attendance recorded" do
      let(:generator) { MonthlyReportGenerator.new(workplace:, year: 2025, month: 9) }

      before do
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 12:34:56"))
        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-01 17:00:00"))
        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-01 22:33:44"))

        workplace.attendance_records.create!(event: "clock-in", recorded_at: Time.zone.parse("2025-09-02 15:01:02"))

        workplace.attendance_records.create!(event: "clock-out", recorded_at: Time.zone.parse("2025-09-30 18:11:22"))
      end

      subject(:result) { generator.generate }

      it "generates working_times including incomplete ones" do
        date_0901 = Date.parse("2025-09-01")
        date_0902 = Date.parse("2025-09-02")
        date_0930 = Date.parse("2025-09-30")
        expect(result.keys).to eq [date_0901, date_0902, date_0930]

        working_times_0901 = result[date_0901]
        expect(working_times_0901.length).to eq 2
        expect(working_times_0901[0].clock_in.recorded_at).to eq Time.zone.parse("2025-09-01 12:34:56")
        expect(working_times_0901[0].clock_out.recorded_at).to eq Time.zone.parse("2025-09-01 17:00:00")
        expect(working_times_0901[1].clock_in.recorded_at).to eq Time.zone.parse("2025-09-01 22:33:44")

        working_times_0902 = result[date_0902]
        expect(working_times_0902.length).to eq 1
        expect(working_times_0902[0].clock_in.recorded_at).to eq Time.zone.parse("2025-09-02 15:01:02")

        working_times_0930 = result[date_0930]
        expect(working_times_0930.length).to eq 1
        expect(working_times_0930[0].clock_out.recorded_at).to eq Time.zone.parse("2025-09-30 18:11:22")
      end
    end
  end
end
