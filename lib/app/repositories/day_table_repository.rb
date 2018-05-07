class DayTableRepository < Hanami::Repository
  def initialize(project_id)
    super()
    @project_id = project_id
  end

  def date?(date)
    day_tables.where(project_id: @project_id, date: date).first
  end

  def clear_day_table
    day_tables.where(project_id: @project_id).delete
  end

  # def get_tables(num)
  #   tables = get_day_table(num)
  #   all = []
  #   tables.each do |day|
  #     times = TimeTableRepository.new(@project_id).get_tables(day.date)
  #     dayline = []
  #     times.each do |time|
  #       time_period = TimePeriod.new(time.time)
  #       unless time_period.start < DateTime.now && day.date == Date.today
  #         dayline << { time: time.time, remain: time.remain }
  #       end
  #     end
  #     all << { date: day.date.to_s, wday: day.date.wday, table: dayline } unless dayline.empty?
  #   end
  #   all
  # end

  def get_tables(num)
    tables = get_day_table(num)
    max_date = max_date(tables)
    time_tables = TimeTableRepository.new(@project_id).get_tables(max_date).to_a
    all = []
    time_tables.each do |table|
      append_table(all, table)
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

  def append_table(all, time_table)
    all.each do |dayline|
      if dayline[:date] == time_table.date.to_s && !time_table.out_of_date?
        dayline[:table] << { time: time_table.time, remain: time_table.remain }
        return
      end
    end
    unless time_table.out_of_date?
      all << { date: time_table.date.to_s,
               wday: time_table.date.wday,
               table: [{ time: time_table.time, remain: time_table.remain }] } 
    end
  end

  def get_day_table(num)
    tables = day_tables.where(project_id: @project_id)
                       .where { date >= Date.today }
                       .limit(num)
    if tables.count < num
      TimeTableUtils.make_time_table(@project_id)
      day_tables.where(project_id: @project_id)
                       .where { date >= Date.today }
                       .limit(num)
    else
      tables
    end
  end
end
