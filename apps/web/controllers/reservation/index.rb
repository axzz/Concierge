require_relative './find_project'

module Web::Controllers::Reservation
  class Index
    include Web::Action
    include FindProject

    expose :count, :reservations

    def call(params)
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      @reservations = get_reservations(params, page)
      @count = get_reservations_count(params)
    end

    private

    def get_reservations(params, page)
      ReservationRepository.new.inquire(@project.id,
                                        params[:date_from],
                                        params[:date_to],
                                        params[:tel],
                                        params[:state],
                                        page)
    end

    def get_reservations_count(params)
      ReservationRepository.new.count_inquire(@project.id,
                                              params[:date_from],
                                              params[:date_to],
                                              params[:tel],
                                              params[:state])
    end
  end
end
