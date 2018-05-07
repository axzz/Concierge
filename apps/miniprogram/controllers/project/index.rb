module Miniprogram::Controllers::Project
  # Api for get projects list
  class Index
    include Miniprogram::Action
    params do
      optional(:token).maybe
      optional(:page).maybe
      optional(:search).maybe
      optional(:distance).maybe
      optional(:latitude).maybe
      optional(:longitude).maybe
      
    end
    expose :projects

    def call(params)
      page = params[:page] || 1
      page = page.to_i > 0 ? page.to_i : 1
      @projects = get_projects(params, page)
    end

    private
    
    def get_projects(params, page)
      project_repository = ProjectRepository.new
      if params[:search]
        project_repository.search(params[:search], page)
      elsif !params[:distance].blank?
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
  end
end
