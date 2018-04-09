module Web::Controllers::Project
  class Show
    include Web::Action

    params do
      optional(:token).maybe(:str?)
      required(:id).filled()
    end

    def call(params)
      project = ProjectRepository.new.find(params[:id])
      halt 422, "项目不存在" unless project
      halt 401, "没有查看此项目的权限" unless project.creator_id == @user.id
      self.body = {
        name:         project.name,
        description:  project.description||"",
        image:        project.image_url[0] == '/' ? "http://192.168.31.208" + project.image_url : project.image_url,
        address:      project.address||"",
        latitude:     project.latitude||"",
        longtitude:   project.longtitude||"",
        time_state:   project.time_state,
        check_mode:   project.check_mode
      }.to_json
    end
  end
end
