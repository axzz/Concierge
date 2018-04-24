require_relative './test_params'
module Web::Controllers::Reservation
  class Refuse
    include Web::Action
    include TestParams

    def call(params)
      halt 400 unless @reservation.state == 'wait'
      ReservationRepository.new.update(@reservation.id, 
                                       state: 'refused', 
                                       remark: params[:remark])
      halt 201,''
    end
  end
end
