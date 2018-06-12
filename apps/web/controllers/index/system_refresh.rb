module Web::Controllers::Index
  class SystemRefresh
    include Web::Action

    def call(_params)
      now = Time.now
      if now.hour == 8 && now.min.zero?
        ProjectRepository.new.everyday_send_to_manager
      end
      ReservationRepository.new.refresh_reservations
      ReservationRepository.new.one_hour_notice
      self.body = 'OK'
    end

    def authenticate!
      # skip auth
    end
  end
end
