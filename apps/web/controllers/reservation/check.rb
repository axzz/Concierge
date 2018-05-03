require_relative './find_reservation'

module Web::Controllers::Reservation
  class Check
    include Web::Action
    include FindReservation

    def call(params)      
      halt 400 unless @reservation.state == 'success'
      ReservationRepository.new.update(@reservation.reservation_id, state: 'checked')
      halt 201,''
    end
  end
end
