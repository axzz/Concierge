module Web::Controllers::Project
  class Authority
    include Web::Action

    def call(params)
      project_repository = ProjectRepository.new
      project = project_repository.find(params[:id].to_i)
      halt 404 unless project
      halt 401 if project.creator_id != @user.id
      project_repository.update(project.id, authority: params[:authority])
      
      self.body = ''
    end
  end
end
