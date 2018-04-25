module MiniprogramAdmin::Controllers::Project
  class Index
    include MiniprogramAdmin::Action

    params do
      optional(:token).maybe
      optional(:page).maybe
    end

    def call(params)
      page = params[:page].to_i > 0 ? params[:page].to_i : 1

      count = @user.projects_num
      projects = @user.projects_miniprogram(page: page)
      self.body = {
        count: count,
        projects: transform_project(projects)
      }.to_json
    end

    def transform_project(projects)
      response = []
      projects.each do |project|
        back_project = {
          id: project.id,
          name: project.name,
          image: project.image_url,
          state: project.state,
          address: project.address
        }
        response << back_project
      end
      response
    end
  end
end
