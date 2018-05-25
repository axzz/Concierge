module Web::Views::Project
  class Show
    include Web::View
      format :json

      def render
        groups = transform_groups(project.groups)
        puts groups
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
          authority:    project.authority,
          groups:       groups,
          ahead_time:   project.ahead_time
        }.to_json)
      end

      private

      def transform_groups(groups)
        puts groups
        groups.map do |group|
          { id: group.id, name: group.name }
        end
      end
  end
end
