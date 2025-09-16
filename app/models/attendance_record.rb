class AttendanceRecord < ApplicationRecord
  belongs_to :workplace

  validates :event, presence: true, inclusion: {in: ["clock-in", "clock-out"]}
  validates :recorded_at, presence: true

  before_validation { self.recorded_at ||= Time.current }

  def clock_in? = event == "clock-in"

  def clock_out? = event == "clock-out"

  def date = recorded_at.to_date
end
