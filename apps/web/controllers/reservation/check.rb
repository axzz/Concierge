require_relative './find_reservation'

module Web::Controllers::Reservation
  class Check
    include Web::Action
    include FindReservation

    def call(_params)
      halt 400 unless @reservation.state == 'success'
      ReservationRepository.new.update(@reservation.reservation_id,
                                       state: 'checked')
      send_msg_to_customer(@reservation)
      halt 201
    end

    def send_msg_to_customer(reservation)
      tel = reservation.tel
      SmsService.new(tel).success_notice_sms(reservation)
    end
  end
end
