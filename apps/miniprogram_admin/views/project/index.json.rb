module MiniprogramAdmin::Views::Project
  class Index
    include MiniprogramAdmin::View
      format :json

      def render
        raw ({
          count: count,
          projects: transformed_project
        }.to_json)
      end

      private

      def transformed_project
        projects.map do |project|
          {
            id: project[:id],
            name: project[:name],
            image: project[:image_url],
            state: project[:state],
            address: project[:address]
          }
        end
      end
  end
end
