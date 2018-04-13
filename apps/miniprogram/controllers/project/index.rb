module Miniprogram::Controllers::Project
  class Index
    include Miniprogram::Action
    def call(params)
      project_repository = ProjectRepository.new
      page = params[:page] || 1
      page = page.to_i > 0 ? page.to_i : 1
      if params[:search]
        projects = project_repository.search(params[:search], page)
      elsif params[:distance] && params[:latitude] && params[:longitude] && !params[:distance].empty?
        projects = project_repository.get_projects_in_distance(params[:distance], params[:latitude], params[:longitude], page)
      else
        projects = project_repository.get_all_projects(page)
      end

      response = []
      projects.each do |project|
        response << {
          id:           project.id, 
          name:         project.name, 
          description:  project.description||"",
          address:      project.address||"",
          cover:        project.image_url
        }
      end
      self.body = { projects: response }.to_json
    end
  end
end
