class WorkingTime
  attr_reader :clock_in, :clock_out

  def initialize(attendance_record:)
    if attendance_record.clock_in?
      set_clock_in(attendance_record)
    else
      set_clock_out(attendance_record)
    end
  end

  def clock_in=(attendance_record)
    raise "not clock_in" unless attendance_record.clock_in?
    raise "Date mismatch" if clock_out.present? && clock_out.date != attendance_record.date
    @clock_in = attendance_record
  end
  alias_method :set_clock_in, :clock_in=

  def clock_out=(attendance_record)
    raise "not clock_out" unless attendance_record.clock_out?
    raise "Date mismatch" if clock_in.present? && clock_in.date != attendance_record.date
    @clock_out = attendance_record
  end
  alias_method :set_clock_out, :clock_out=

  def started? = clock_in.present?

  def ended? = clock_out.present?

  def complete? = started? && ended?

  def started_at = clock_in&.recorded_at

  def ended_at = clock_out&.recorded_at

  def duration = complete? ? (ended_at - started_at) : 0.0

  def date = (clock_in || clock_out).date
end
