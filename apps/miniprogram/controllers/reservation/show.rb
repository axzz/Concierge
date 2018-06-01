module Miniprogram::Controllers::Reservation
  class Show
    include Miniprogram::Action

    expose :reservation, :project
    
    def call(params)
      id = params[:id]
      @reservation = ReservationRepository.new.find(id)
      halt 404 unless @reservation
      halt 401 unless @reservation.creator_id == @user.id
      @project = ProjectRepository.new.find(@reservation.project_id)
    end
  end
end
