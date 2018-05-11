module Miniprogram::Views::Project
  class Show
    include Miniprogram::View
    format :json

    def render
      time_state_parsed = sort_time_state(project.time_state_parsed)
      raw ({
        cover:        project.image_url,
        name:         project.name,
        state:        project.state,
        description:  project.description || '',
        address:      project.address     || '',
        latitude:     project.latitude    || '',
        longitude:    project.longitude   || '',
        multi_time:   project.multi_time,
        reservation_per_user: project.reservation_per_user,
        reservable:   !user.achieve_limit?(project.id),
        ahead_time:   project.ahead_time,
        time_state:   time_state_parsed,
        full:         full?(time_tables),
        time_table:   time_tables.to_json,
        tmp_tel:      user.tmp_tel       || '',
        tmp_name:     user.tmp_name      || '',
        need_sms:     need_sms?
      }.to_json)
    end

    private

    # Solve postgres incorrect sort
    def sort_time_state(time_state)
      { Mon:     time_state[:Mon],
        Tues:    time_state[:Tues],
        Wed:     time_state[:Wed],
        Thur:    time_state[:Thur],
        Fri:     time_state[:Fri],
        Sat:     time_state[:Sat],
        Sun:     time_state[:Sun],
        Holiday: time_state[:Holiday],
        Special: time_state[:Special] }
    end

    def need_sms?
      !Redis.new.get("need_sms.#{user.id}")
    end

    def full?(time_tables)
      time_tables.each do |time_table|
        time_table[:table].each do |period|
          return false if period[:remain].nil? || period[:remain] > 0
        end
      end
      true
    end
  end
end
