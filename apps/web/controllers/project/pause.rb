module Web::Controllers::Project
  class Pause
    include Web::Action

    def call(params)
      id = params[:id].to_i
      repository = ProjectRepository.new
      project = repository.find(id)
      halt 404 unless project
      halt 403 unless project.creator_id == @user.id

      repository.update(id, state: 'pause')
      ReservationRepository.new.cancel_all(project_id)
      self.body = ''
    end
  end
end
