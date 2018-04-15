module Web::Controllers::Project
  class Show
    include Web::Action

    params do
      optional(:token).maybe(:str?)
      required(:id).filled()
    end

    def call(params)
      project = ProjectRepository.new.find(params[:id])
      halt 422, 'Project not exist' unless project
      halt 401, 'No Auth to access' unless project.creator_id == @user.id
      self.body = {
        name:         project.name,
        description:  project.description || '',
        image:        project.image_url,
        address:      project.address || '',
        latitude:     project.latitude || '',
        longitude:    project.longitude || '',
        time_state:   project.time_state,
        check_mode:   project.check_mode
      }.to_json
    end
  end
end
