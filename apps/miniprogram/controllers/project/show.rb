module Miniprogram::Controllers::Project
  class Show
    include Miniprogram::Action

    def call(params)
      project = ProjectRepository.new.find(params[:id].to_i)
      halt 422, "项目不存在" unless project
      time_table = DayTableRepository.new.get_tables(project.id, 7)
      self.body = {
        cover:        project.image_url,
        name:         project.name,
        description:  project.description||"",
        address:      project.address||"",
        latitude:     project.latitude||"",
        longitude:    project.longitude||"",
        time_state:   project.time_state_parsed,
        time_table:   time_table.to_json
      }.to_json
    end
  end
end
