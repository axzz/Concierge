class TimeTableRepository < Hanami::Repository
  def find_time_table(project_id, date)
    time_tables.where(project_id: project_id, date: date).order{ id.desc }
  end
  
  def have_time_table?(project_id, date, period)
    time_tables.where(project_id: project_id, date: date, period: period).first
  end
  
  def clear_time_table(project_id)
    time_tables.where(project_id: project_id).delete
  end

  def get_tables(project_id, date)
    time_tables.where(project_id: project_id).where(date: date)
  end
end
