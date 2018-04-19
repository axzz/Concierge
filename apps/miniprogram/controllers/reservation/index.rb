module Miniprogram::Controllers::Reservation
  class Index
    include Miniprogram::Action
    params do
      optional(:page).maybe
      optional(:search).maybe(:str?)
      optional(:type).maybe(:str?)
    end

    def call(params)
      page = params[:page].to_i > 0 ? params[:page].to_i : 1

      reservations = get_reservations(params, page)

      self.body = { reservations: transform_reservations(reservations) }.to_json
    end

    def get_reservations(params, page)
      repository = ReservationRepository.new
      if params[:search]
        repository.search(params[:search], @user.id, page)
      elsif params[:type] == 'current' # on dealing
        repository.current_user_reservations(@user.id, page)
      elsif params[:type] == 'finished' # history
        repository.finished_user_reservations(@user.id, page)
      elsif params[:type] == 'cancelled'
        repository.cancelled_user_reservations(@user.id, page)
      elsif params[:type] == 'refused'
        repository.refused_user_reservations(@user.id, page)
      else
        repository.basic_user_reservations(@user.id, page)
      end
    end

    def transform_reservations(reservations)
      response = []
      project_repository = ProjectRepository.new
      reservations.each do |reservation|
        project = project_repository.find(reservation.project_id)
        response << {
          id:           reservation.id,
          state:        reservation.state,
          project_name: project.name,
          address:      project.address || '',
          date:         reservation.date,
          time:         reservation.time,
          name:         reservation.name,
          tel:          reservation.tel
        }
      end
      response
    end
  end
end
