module Miniprogram::Controllers::Project
  # Api for get projects list
  class Index
    include Miniprogram::Action
    params do
      optional(:page).maybe
      optional(:search).maybe
      optional(:distance).maybe
      optional(:latitude).maybe
      optional(:longitude).maybe
      
    end
    def call(params)
      page = params[:page] || 1
      page = page.to_i > 0 ? page.to_i : 1
      projects = get_projects(params, page)

      self.body = { projects: transform_projects(projects) }.to_json
    end

    def get_projects(params, page)
      project_repository = ProjectRepository.new
      if params[:search]
        project_repository.search(params[:search], page)
      elsif params[:distance] && !params[:distance].empty?
        project_repository
          .get_projects_in_distance(
            params[:distance],
            params[:latitude],
            params[:longitude],
            page
          )
      else
        project_repository.get_all_projects(page)
      end
    end

    # Transform projects dataform from object to hash
    def transform_projects(projects)
      response = []
      projects.each do |project|
        response << { id:           project.id,
                      name:         project.name,
                      description:  project.description || '',
                      address:      project.address || '',
                      cover:        project.image_url }
      end
      response
    end
  end
end
