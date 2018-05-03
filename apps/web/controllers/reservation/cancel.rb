require_relative './find_reservation'

module Web::Controllers::Reservation
  class Cancel
    include Web::Action
    include FindReservation
    
    def call(params)
      halt 400 unless @reservation.state == 'success' || @reservation.state == 'wait'
      add_remain
      ReservationRepository.new.update(@reservation.reservation_id, 
                                       state: 'cancelled', 
                                       remark: params[:remark])
      halt 201,''
    end

    private 

    def add_remain
      TimeTableRepository.new(@project.id)
                         .add_remain(@reservation.date, @reservation.time) 
    end
  end
end
