require_relative './find_project'

module Web::Controllers::Reservation
  class Count
    include Web::Action
    include FindProject

    def call(params)
      self.body = ReservationRepository.new
                                       .count(@project.id)
                                       .to_json
    end
  end
end
