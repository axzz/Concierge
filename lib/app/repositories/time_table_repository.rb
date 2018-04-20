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

  def clear_time_table
    time_tables.where(project_id: @project_id).delete
  end

  def get_tables(date)
    time_tables.where(project_id: @project_id).where(date: date)
  end

  def reduce_remain(date, time)
    time_table = time_tables
                 .where(project_id: @project_id, date: date, time: time)
                 .first
    update(time_table.id, remain: time_table.remain - 1) unless time_table.remain.nil?
  end
end
