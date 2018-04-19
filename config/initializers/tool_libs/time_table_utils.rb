class TimeTableUtils
  DAY_NUM = 20

  def self.parse_time_state(time_state)
    time_state_parsed = default_time_state
    time_state['normal'].each do |period|
      period['weekday'].each do |day|
        raise 'Fail in parse time' unless period['time'] =~ /\d{2}:\d{2}-\d{2}:\d{2}/
        time_state_parsed[day.to_sym] << { time: period['time'], limit: period['limit'] }
      end
    end

    time_state_parsed[:Special] = time_state['special']
    time_state_parsed.each do |key, value|
      time_state_parsed[key] = value.sort_by { |a| a[:time] }
    end
  end

  def self.default_time_state
    { Mon: [],
      Tues: [],
      Wed: [],
      Thur: [],
      Fri: [],
      Sat: [],
      Sun: [],
      Holiday: [],
      Special: [] }
  end

  def self.change_time_state(project_id, new_time_state)
    # TODO: cancel reservations
    day_table_repository = DayTableRepository.new(project_id)
    time_table_repository = TimeTableRepository.new(project_id)
    day_table_repository.clear_day_table
    time_table_repository.clear_time_table
    make_time_table(project_id, new_time_state)
    # TODO: calculate remain
  end

  def self.make_time_table(project_id, time_state = nil)
    time_state ||= ProjectRepository.new.find(project_id).time_state_parsed
    created_day = 0
    add_day = 0

    while created_day < DAY_NUM
      this_day = Date.today + add_day
      weekday = this_day.wday
      if this_day.holiday? && !time_state[:Holiday].empty?
        create_time_table(this_day, time_state[:Holiday], project_id)
        created_day += 1
      elsif !time_state[map_weekday[weekday]].empty?
        create_time_table(this_day, time_state[map_weekday[weekday]], project_id)
        created_day += 1
      end
      add_day += 1
    end
  end

  def self.create_time_table(date, state, project_id)
    day_table_repository = DayTableRepository.new(project_id)
    time_table_repository = TimeTableRepository.new(project_id)

    unless day_table_repository.date?(date)
      date_table = DayTable.new(project_id: project_id, date: date)
      day_table_repository.create(date_table)
    end
    
    state.each do |period|
      next if time_table_repository.period?(date, period[:time])
      time_table = TimeTable.new(project_id: project_id,
                                 date: date,
                                 period: period[:time],
                                 remain: period[:limit])
      time_table_repository.create(time_table)
    end
  end

  def self.map_weekday
    {
      0 => :Sun,
      1 => :Mon,
      2 => :Tues,
      3 => :Wed,
      4 => :Thur,
      5 => :Fri,
      6 => :Sat
    }
  end
end