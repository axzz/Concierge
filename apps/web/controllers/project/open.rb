module Web::Controllers::Project
  class Open
    include Web::Action

    def call(params)
      id = params[:id].to_i
      repository = ProjectRepository.new
      project = repository.find(id)
      halt 404 unless project
      halt 403 unless project.creator_id == @user.id

      repository.update(id, state: 'open')
      self.body = ''
    end
  end
end
