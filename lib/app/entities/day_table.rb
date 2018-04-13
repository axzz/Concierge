class DayTable < Hanami::Entity
  def time_tables
    TimeTableRepository.new.find_time_table(id,date)
  end
end
