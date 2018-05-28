require_relative './find_reservation'

module Web::Controllers::Reservation
  class Cancel
    include Web::Action
    include FindReservation
    
    def call(params)
      halt 400 unless @reservation.state == 'success' ||
                      @reservation.state == 'wait'
      add_remain
      @reservation = ReservationRepository.new.update(
                       @reservation.reservation_id,
                       state: 'cancelled',
                       remark: params[:remark]
                     )
      send_msg_to_customer(@reservation)
      halt 201, ''
    end

    private

    def add_remain
      TimeTableRepository.new(@project.id)
                         .add_remain(@reservation.date, @reservation.time)
    end

    def send_msg_to_customer(reservation)
      tel = reservation.tel
      SmsService.new(tel).manager_cancel_sms(reservation)
    end
  end
end
