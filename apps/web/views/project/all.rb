module Web::Views::Project
  class All
    include Web::View
    format :json

    def render
      raw ({
        projects: transformed_projects
      }.to_json)
    end

    private

    def transformed_projects
      projects.map do |project|
        {
          id: project[:id],
          name: project[:name]
        }
      end
    end
  end
end
