require_relative './find_project'

module Web::Controllers::Project
  class Show
    include Web::Action
    include FindProject

    expose :project

    params do
      optional(:token).maybe(:str?)
      required(:id).filled()
    end

    def call(params)
      puts project.groups
      halt 422 unless params.valid?
    end
  end
end
