require_relative './find_project'

module Web::Controllers::Project
  class Open
    include Web::Action
    include FindProject

    def call(params)
      repository = ProjectRepository.new
      repository.update(@project.id, state: 'open')
      self.body = ''
    end
  end
end
