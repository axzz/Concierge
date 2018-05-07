class TimeTable < Hanami::Entity
  def reduce_remain
    TimeTableRepository.new(project_id).reduce_remain(date, time)
  end

  def out_of_date?
    if date > Date.today
      false
    elsif date == Date.today
      time_period = TimePeriod.new(time)
      if time_period.start < DateTime.now
        true
      else
        false
      end
    else 
      true
    end
  end
end
