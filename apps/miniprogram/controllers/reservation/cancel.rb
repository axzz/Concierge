module Miniprogram::Controllers::Reservation
  class Cancel
    include Miniprogram::Action

    def call(params)
      reservation = ReservationRepository.new.find(params[:id].to_i)
      halt 404 unless reservation
      halt 403 unless reservation.creator_id == @user.id

      add_remain(reservation)
      ReservationRepository.new.update(reservation.reservation_id,
                                       state: 'cancelled',
                                       remark: '用户取消预约')
      send_msg_to_customer(reservation)
      halt 201
    end

    private
    
    def add_remain(reservation)
      return if reservation.state != 'success' && reservation.state != 'wait'
      TimeTableRepository.new(reservation.project_id)
                         .add_remain(reservation.date, reservation.time)
    end

    def send_msg_to_customer(reservation)
      tel = reservation.tel
      SmsService.new(tel).customer_cancel_sms(reservation)
    end
  end
end
