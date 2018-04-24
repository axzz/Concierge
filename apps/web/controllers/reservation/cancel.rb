require_relative './test_params'
module Web::Controllers::Reservation
  class Cancel
    include Web::Action
    include TestParams
    
    def call(params)
      halt 400 unless @reservation.state == 'success'
      ReservationRepository.new.update(@reservation.id, 
                                       state: 'cancelled', 
                                       remark: params[:remark])
      halt 201,''
    end
  end
end
