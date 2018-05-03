module Web::Controllers::Reservation
  module FindReservation
    def self.included(action)
      action.class_eval do
        before :find_reservation
      end
    end

    private

    def find_reservation(params)
      @project = ProjectRepository.new.find(params[:project_id])
      @reservation = ReservationRepository.new.find(params[:reservation_id])
      halt 404 unless @reservation && @project
      halt 401 unless @reservation.project_id == @project.id
      halt 401 unless @project.creator_id == @user.id
    end
  end
end