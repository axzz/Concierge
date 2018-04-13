class TimeTableUtils
  @@day_table_repository = DayTableRepository.new
  @@time_table_repository = TimeTableRepository.new
  DAY_NUM = 20
  def self.parse_time_state(time_state)
    time_state_parsed={
      Mon: [],
      Tues: [],
      Wed: [],
      Thur: [],
      Fri: [],
      Sat: [],
      Sun: [],
      Holiday: [],
      Special: []
    }
    time_state["normal"].each do |period|
      period["weekday"].each do |day|
        raise "Fail in parse time"  unless period["time"] =~ /\d{2}:\d{2}-\d{2}:\d{2}/
        raise "Fail in parse limit" unless period["limit"].class == Fixnum
        time_state_parsed[day.to_sym] << {time: period["time"], limit: period["limit"]}
      end
    end
    time_state_parsed[:Special] = time_state["special"]
  
    time_state_parsed.each do |key,value|
      time_state_parsed[key] = value.sort { |a, b|  a[:time] <=> b[:time] }
    end
  end

  def self.change_time_state(project_id, new_time_state)
    # TODO (L): 取消所有不符的预约

    # 重置time_tables
    @@time_table_repository.clear_time_table(project_id)
    make_time_table(project_id, new_time_state)
    # TODO (L): 计算remain

  end

  def self.make_time_table(project_id, time_state = nil)
    time_state = ProjectRepository.new.find(project_id).time_state_parsed unless time_state

    created_day = 0
    add_day = 0
    while created_day < DAY_NUM
      this_day = Date.today + add_day
      if this_day.holiday? && !time_state[:Holiday].empty?
        create_time_table(this_day, time_state[:Holiday], project_id)
      elsif this_day.sunday? && !time_state[:Sun].empty?
        create_time_table(this_day, time_state[:Sun], project_id)
      elsif this_day.monday? && !time_state[:Mon].empty?
        create_time_table(this_day, time_state[:Mon], project_id)
      elsif this_day.tuesday? && !time_state[:Tues].empty?
        create_time_table(this_day, time_state[:Tues], project_id)
      elsif this_day.wednesday? && !time_state[:Wed].empty?
        create_time_table(this_day, time_state[:Wed], project_id)
      elsif this_day.thursday? && !time_state[:Thur].empty?
        create_time_table(this_day, time_state[:Thur], project_id)
      elsif this_day.friday? && !time_state[:Fri].empty?
        create_time_table(this_day, time_state[:Fri], project_id)
      elsif this_day.saturday? && !time_state[:Sat].empty?
        create_time_table(this_day, time_state[:Sat], project_id)
      else
        created_day -= 1
      end
      created_day += 1
      add_day += 1
    end
  end

private

  def self.create_time_table(date, state, project_id)
    unless @@day_table_repository.have_date?(project_id, date)
      date_table = DayTable.new(project_id: project_id,date: date)
      @@day_table_repository.create(date_table)
    end
    state.each do |period|
      unless @@time_table_repository.have_time_table?(project_id, date, period[:time])
        time_table = TimeTable.new(project_id: project_id, date: date, period: period[:time], remain: period[:limit])
        @@time_table_repository.create(time_table)
      end
    end
  end
  
end