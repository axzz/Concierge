module Miniprogram::Controllers::Project
  class Show
    include Miniprogram::Action

    def call(params)
      project = ProjectRepository.new.find(params[:id].to_i)
      halt 422, "项目不存在" unless project
      time_table = DayTableRepository.new.get_tables(project.id, 7)
      time_state_parsed = sort_time_state(project.time_state_parsed)
      self.body = {
        cover:        project.image_url,
        name:         project.name,
        description:  project.description||"",
        address:      project.address||"",
        latitude:     project.latitude||"",
        longitude:    project.longitude||"",
        time_state:   time_state_parsed,
        time_table:   time_table.to_json
      }.to_json
    end

    def sort_time_state(unsorted_time_state)
      sorted_time_state = {
        Mon: unsorted_time_state[:Mon],
        Tues: unsorted_time_state[:Tues],
        Wed: unsorted_time_state[:Wed],
        Thur: unsorted_time_state[:Thur],
        Fri: unsorted_time_state[:Fri],
        Sat: unsorted_time_state[:Sat],
        Sun: unsorted_time_state[:Sun],
        Holiday: unsorted_time_state[:Holiday],
        Special: unsorted_time_state[:Special]
      }
    end
  end
end
