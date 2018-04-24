module Web::Controllers::Reservation
  class Index
    include Web::Action

    def call(params)
      project = ProjectRepository.new.find(params[:id].to_i)
      halt 404 unless project
      halt 403 unless project.creator_id == @user.id

      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      reservations = get_reservations(project.id, params, page)
      
      self.body = { reservations: transform_reservations(reservations) }.to_json
    end

    private

    def get_reservations(project_id, params, page)
      ReservationRepository.new.inquire(project_id,
                                        params[:date_from],
                                        params[:date_to],
                                        params[:tel],
                                        params[:state],
                                        page)
    end

    def transform_reservations(reservations)
      response = []
      reservations.each do |reservation|
        response << {
          id:           reservation.id,
          state:        reservation.state,
          date:         reservation.date,
          time:         reservation.time,
          name:         reservation.name,
          tel:          reservation.tel,
          remark:       reservation.remark
        }
      end
      response
    end
  end
end
