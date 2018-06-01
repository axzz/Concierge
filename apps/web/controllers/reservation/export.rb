require_relative './find_project'

module Web::Controllers::Reservation
  class Export
    include Web::Action
    include FindProject

    def call(params)
      reservations = get_reservations(params)
      path = CsvTools.new.make_reservation_csv(reservations, @project.id)
      self.body = path
    end

    private

    def get_reservations(params)
      ReservationRepository.new.inquire(@project.id,
                                        params[:date_from],
                                        params[:date_to],
                                        params[:tel],
                                        params[:state],
                                        1,
                                        10_000_000).to_a
    end

  end
end
