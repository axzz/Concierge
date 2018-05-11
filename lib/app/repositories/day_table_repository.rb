class DayTableRepository < Hanami::Repository
  def initialize(project_id)
    super()
    @project_id = project_id
    @project = ProjectRepository.new.find(project_id)
  end

  def date?(date)
    day_tables.where(project_id: @project_id, date: date).first
  end

  def clear_day_table
    day_tables.where(project_id: @project_id).delete
  end

  def get_tables(num)
    min_time = @project.min_time
    tables = get_day_table(num, min_time.to_date)
    max_date = max_date(tables)
    time_tables = TimeTableRepository.new(@project_id).get_tables(min_time.to_date, max_date).to_a
    all = []
    time_tables.each do |table|
      append_table(all, table, min_time)
    end
    all
  end

  def max_date(day_tables)
    max_date = Date.today
    day_tables.each do |day_table|
      max_date = day_table.date if day_table.date > max_date
    end
    max_date
  end

  def append_table(all, time_table, min_time)
    return if time_table.out_of_date?(min_time)
    all.each do |dayline|
      if dayline[:date] == time_table.date.to_s
        dayline[:table] << { time: time_table.time, remain: time_table.remain }
        return
      end
    end
    all << { date: time_table.date.to_s,
             wday: time_table.date.wday,
             table: [{ time: time_table.time, remain: time_table.remain }] } 
  end

  def get_day_table(num, min_date)
    tables = day_tables.where(project_id: @project_id)
                       .where { date >= min_date }
                       .limit(num)
    if tables.count < num
      TimeTableUtils.make_time_table(@project_id,
                                     min_date,
                                     @project.time_state_parsed
                                     )
      day_tables.where(project_id: @project_id)
                       .where { date >= min_date }
                       .limit(num)
    else
      tables
    end
  end
end
