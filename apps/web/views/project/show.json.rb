module Web::Views::Project
  class Show
    include Web::View
      format :json

      def render
        raw ({
          name:         project.name,
          description:  project.description || '',
          state:        project.state,
          image:        project.image_url,
          address:      project.address || '',
          latitude:     project.latitude || '',
          longitude:    project.longitude || '',
          time_state:   project.time_state,
          check_mode:   project.check_mode,
          multi_time:   project.multi_time,
          reservation_per_user: project.reservation_per_user,
          date_display: project.date_display,
          ahead_time:   project.ahead_time
        }.to_json)
      end
  end
end
