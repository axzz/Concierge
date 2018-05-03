require_relative './find_project'

module Web::Controllers::Project
  class Pause
    include Web::Action
    include FindProject

    def call(params)
      repository = ProjectRepository.new
      repository.update(@project.id, state: 'pause')
      repository.cancel_all(@project.id)
      self.body = ''
    end
  end
end
