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
          check_mode:   project.check_mode
        }.to_json)
      end
  end
end
