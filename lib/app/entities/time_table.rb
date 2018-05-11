class TimeTable < Hanami::Entity
  def reduce_remain
    TimeTableRepository.new(project_id).reduce_remain(date, time)
  end

  def out_of_date?(min_time = DateTime.now)
    min_date = min_time.to_date
    if date > min_date
      false
    elsif date == min_date
      time_period = TimePeriod.new(time)
      if time_period.start < min_time
        true
      else
        false
      end
    else 
      true
    end
  end
end
