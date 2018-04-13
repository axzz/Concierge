class DayTableRepository < Hanami::Repository
  def have_date?(id,date)
    day_tables.where(project_id: id, date: date).first
  end

  def clear_day_table(id)
    day_tables.where(creator_id: id).delete
  end

  def get_tables(project_id, num)
    tables = day_tables.where(project_id: project_id).where{ date >= Date.today }.limit(num)
    if tables.count < num
      TimeTableUtils.make_time_table(project_id)
      get_tables(project_id, num)
    else
      all = []
      tables.each do |day|
        periods = TimeTableRepository.new.get_tables(project_id, day.date)
        dayline = []
        periods.each do |period|
          dayline << { time: period.period, remain: period.remain }
        end
        all << { date: day.date.to_s, wday: day.date.wday, table: dayline  }
      end
      all
    end
  end
end

