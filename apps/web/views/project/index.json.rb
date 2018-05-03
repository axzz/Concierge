module Web::Views::Project
  class Index
    include Web::View
      format :json

      def render
        raw ({
          count: count,
          projects: transformed_projects
        }.to_json)
      end

      private

      def transformed_projects
        projects.map do |project|
          {
            id: project[:id],
            name: project[:name],
            image: project[:image_url],
            state: project[:state],
          }
        end
      end
  end
end
