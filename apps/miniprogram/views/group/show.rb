module Miniprogram::Views::Group
  class Show
    include Miniprogram::View
    format :json

    def render
      raw ({
        name: group.name
      }.to_json)
    end

  end
end
