module Miniprogram::Controllers::Reservation
  class Index
    include Miniprogram::Action
    params do
      optional(:token).maybe
      optional(:page).maybe
      optional(:search).maybe(:str?)
      optional(:type).maybe(:str?)
    end

    expose :reservations

    def call(params)
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      @reservations = get_reservations(params, page).to_a
    end

    private

    def get_reservations(params, page)
      repository = ReservationRepository.new
      if params[:search]
        repository.search(params[:search], @user.id, page)
      elsif params[:type] == 'current' # on dealing
        repository.current_user_reservations(@user.id, page)
      elsif params[:type] == 'finished' # history
        repository.finished_user_reservations(@user.id, page)
      elsif params[:type] == 'cancelled'
        repository.cancelled_user_reservations(@user.id, page)
      elsif params[:type] == 'refused'
        repository.refused_user_reservations(@user.id, page)
      else
        repository.basic_user_reservations(@user.id, page)
      end
    end
  end
end
