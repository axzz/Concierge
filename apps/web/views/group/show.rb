module Web::Views::Group
  class Show
    include Web::View
    format :json

    def render
      raw ({
        name: group.name,
        projects: (projects.map &:id)
      }.to_json)
    end

  end
end
