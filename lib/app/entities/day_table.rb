class DayTable < Hanami::Entity
  def time_tables
    TimeTableRepository.new(project_id).find_time_table(date)
  end
end
