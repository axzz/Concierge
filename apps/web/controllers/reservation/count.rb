module Web::Controllers::Reservation
  class Count
    include Web::Action

    def call(params)
      project = ProjectRepository.new.find(params[:project_id].to_i)
      halt 404 unless project
      halt 403 unless project.creator_id == @user.id

      self.body = ReservationRepository.new.count(params[:project_id].to_i).to_json
    end
  end
end
