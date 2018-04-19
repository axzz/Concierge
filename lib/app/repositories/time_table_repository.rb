class TimeTableRepository < Hanami::Repository
  def initialize(project_id)
    super()
    @project_id = project_id
  end

  def find_time_table(date)
    time_tables.where(project_id: @project_id, date: date).order{ id.desc }
  end

  def period?(date, period)
    time_tables.where(project_id: @project_id, date: date, period: period).first
  end

  def clear_time_table
    time_tables.where(project_id: @project_id).delete
  end

  def get_tables(date)
    time_tables.where(project_id: @project_id).where(date: date)
  end

  def reduce_remain(date, time)
    time_table = time_tables.where(project_id: @project_id, date: date, period: time).first
    update(time_table.id, remain: time_table.remain - 1)
  end
end
