class MonthlyWorkingTime
  include Enumerable

  attr_reader :year, :month
  private attr_reader :daily_working_times

  def initialize(year:, month:, working_times:)
    @year = year
    @month = month
    @daily_working_times = build(working_times:)
  end

  delegate :each, to: :daily_working_times

  private

  def build(working_times:)
    date_from = Date.new(year, month)
    date_range = (date_from..date_from.end_of_month)

    date_range.each_with_object({}) do |date, hash|
      hash[date] = DailyWorkingTime.new(date:, working_times: working_times[date] || [])
    end
  end
end
