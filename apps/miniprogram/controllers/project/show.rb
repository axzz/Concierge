module Miniprogram::Controllers::Project
  # Api for get one project
  class Show
    include Miniprogram::Action
    def call(params)
      project = ProjectRepository.new.find(params[:id].to_i)
      halt 422, '项目不存在' unless project
      time_table = DayTableRepository.new.get_tables(project.id, 7)
      time_state_parsed = sort_time_state(project.time_state_parsed)

      self.body = {
        cover:        project.image_url,
        name:         project.name,
        description:  project.description || '',
        address:      project.address     || '',
        latitude:     project.latitude    || '',
        longitude:    project.longitude   || '',
        time_state:   time_state_parsed,
        time_table:   time_table.to_json
      }.to_json
    end

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
  end
end
