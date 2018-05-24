module Web::Views::Group
  class Index
    include Web::View
    format :json

    def render
      raw transformed_groups.to_json
    end

    private

    def transformed_groups
      groups.map do |group|
        {
          id: group.id,
          name: group.name,
          total: group.total,
          wxcode: group.wx_code
        }
      end
    end
  end
end
