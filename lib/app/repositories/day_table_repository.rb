class DayTableRepository < Hanami::Repository
  def date?(id, date)
    day_tables.where(project_id: id, date: date).first
  end

  def clear_day_table(id)
    day_tables.where(project_id: id).delete
  end

  def get_tables(project_id, num)
    tables = get_day_table(project_id, num)
    TimeTableUtils.make_time_table(project_id) if tables.count < num
    tables = get_day_table(project_id, num)
    all = []
    tables.each do |day|
      periods = TimeTableRepository.new.get_tables(project_id, day.date)
      dayline = []
      periods.each do |period|
        dayline << { time: period.period, remain: period.remain }
      end
      all << { date: day.date.to_s, wday: day.date.wday, table: dayline }
    end
    all
  end

  def get_day_table(project_id, num)
    day_tables
      .where(project_id: project_id)
      .where { date >= Date.today }
      .limit(num)
  end
end
