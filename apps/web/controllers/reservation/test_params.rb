module Web::Controllers::Reservation
  module TestParams
    def self.included(action)
      action.class_eval do
        before :test_params
      end
    end

    private

    def test_params(params)
      @project = ProjectRepository.new.find(params[:project_id])
      @reservation = ReservationRepository.new.find(params[:reservation_id])
      halt 404 unless @reservation && @project
      halt 403 unless @reservation.project_id == @project.id
      halt 403 unless @project.creator_id == @user.id
    end
  end
end