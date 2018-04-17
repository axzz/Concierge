module Web::Controllers::Project
  class Index
    include Web::Action

    params do
      optional(:token).maybe
      optional(:page).maybe
    end

    def call(params)
      page = params[:page] || 1
      page = page.to_i > 0 ? page.to_i : 1

      count = @user.projects_num
      projects = @user.projects(page: page)

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
          state: project.state
        }
        response << back_project
      end
      response
    end
  end
end
