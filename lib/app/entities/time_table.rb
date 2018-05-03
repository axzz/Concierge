class TimeTable < Hanami::Entity
  def reduce_remain
    TimeTableRepository.new(project_id).reduce_remain(date, time)
  end
end
