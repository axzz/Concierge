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

  def get_tables(num)
    tables = get_day_table(num)
    TimeTableUtils.make_time_table(@project_id) if tables.count < num
    tables = get_day_table(num)
    all = []
    tables.each do |day|
      periods = TimeTableRepository.new(@project_id).get_tables(day.date)
      dayline = []
      periods.each do |period|
        dayline << { time: period.period, remain: period.remain }
      end
      all << { date: day.date.to_s, wday: day.date.wday, table: dayline }
    end
    all
  end

  def get_day_table(num)
    day_tables.where(project_id: @project_id).where { date >= Date.today }.limit(num)
  end
end
