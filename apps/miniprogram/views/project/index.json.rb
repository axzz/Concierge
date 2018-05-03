module Miniprogram::Views::Project
  class Index
    include Miniprogram::View
      format :json

      def render
        raw ({
          projects: transformed_projects
        }.to_json)
      end

      private

      def transformed_projects
        projects.map do |project|
          { id:           project[:id],
            name:         project[:name],
            description:  project[:description] || '',
            address:      project[:address] || '',
            cover:        project[:image_url] }
        end
      end
  end
end
