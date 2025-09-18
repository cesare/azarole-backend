class DailyWorkingTime
  include Enumerable

  attr_reader :date
  private attr_reader :working_times

  def initialize(date:, working_times: [])
    @date = date
    @working_times = working_times
  end

  delegate :each, :length, :[], to: :working_times

  def day = date.day

  def has_error? = working_times.any? { !it.complete? }

  def time_tracked = working_times.sum { it.duration.round }
end
