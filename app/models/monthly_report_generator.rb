class MonthlyReportGenerator
  private attr_reader :workplace, :year, :month

  def initialize(workplace:, year:, month:)
    @workplace = workplace
    @year = year
    @month = month
  end

  def generate = working_times.group_by { it.date }

  private

  def target_attendance_records
    beginning_of_month = Time.zone.local(year, month)
    end_of_month = beginning_of_month.next_month

    workplace.attendance_records
      .where(recorded_at: (beginning_of_month...end_of_month))
      .order(:recorded_at)
  end

  def working_times
    target_attendance_records.each_with_object([]) do |attendance_record, working_times|
      last_working_time = working_times.last

      if last_working_time.blank?
        working_times << WorkingTime.new(attendance_record:)
        next
      end

      if attendance_record.clock_in?
        working_times << WorkingTime.new(attendance_record:)
        next
      end

      if last_working_time.ended? || last_working_time.date != attendance_record.date
        working_times << WorkingTime.new(attendance_record:)
        next
      end

      last_working_time.clock_out = attendance_record
    end
  end
end
