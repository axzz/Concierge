require_relative './find_reservation'
module Web::Controllers::Reservation
  class Pass
    include Web::Action
    include FindReservation

    def call(params)
      sleep 10
      halt 400 unless @reservation.state == 'wait'
      ReservationRepository.new.update(@reservation.reservation_id,
                                       state: 'success')
      halt 201,''
    end
  end
end
