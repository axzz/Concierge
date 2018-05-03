module Miniprogram::Controllers::Reservation
  class Cancel
    include Miniprogram::Action

    def call(params)
      reservation = ReservationRepository.new.find(params[:id].to_i)
      halt 404 unless reservation
      halt 403 unless reservation.creator_id == @user.id

      if reservation.state == 'success' || reservation.state =='wait'
        TimeTableRepository.new(reservation.project_id)
                           .add_remain(reservation.date, reservation.time) 
      end

      ReservationRepository.new.update(reservation.reservation_id, 
                                       state: 'cancelled', 
                                       remark: '用户取消预约')
      halt 201
    end
  end
end
