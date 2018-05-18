class TimeTableRepository < Hanami::Repository
  def initialize(project_id)
    super()
    @project_id = project_id
  end

  def find_time_table(date)
    time_tables.where(project_id: @project_id, date: date).order{ id.desc }
  end

  def time?(date, time)
    time_tables.where(project_id: @project_id, date: date, time: time).first
  end

  def times?(date, times)
    time_tables
      .where(project_id: @project_id, date: date)
      .where { time.in(*times) }
  end

  def clear_time_table
    time_tables.where(project_id: @project_id).delete
  end

  def get_tables(min_date, max_date)
    time_tables.where(project_id: @project_id).where { date >= min_date }.where { date <= max_date }
  end

  def reduce_remain(date, times)
    time_table = time_tables.where(project_id: @project_id, date: date)
                            .where { time.in(*times) }

    time_table.each do |time_line|
      next if time_line.remain.nil?
      return false if time_line.remain < 1
    end

    time_table.each do |time_line|
      next if time_line.remain.nil?
      update(time_line.id, remain: time_line.remain - 1)
    end
  end

  def add_remain(date, times)
    time_table = time_tables
                 .where(project_id: @project_id, date: date)
                 .where { time.in(*times) }
    time_table.each do |time_line|
      next if time_line.remain.nil?
      update(time_line.id, remain: time_line.remain + 1)
    end
  end
end
