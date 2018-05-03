module Web::Controllers::Reservation
  module FindProject

    def self.included(action)
      action.class_eval do
        before :find_project
      end
    end

    private

    def find_project(params)
      @project = ProjectRepository.new.find(params[:project_id].to_i)
      halt 404 unless @project
      halt 401 unless @project.creator_id == @user.id
    end
  end
end