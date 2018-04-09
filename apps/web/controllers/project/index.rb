module Web::Controllers::Project
  class Index
    include Web::Action

    params do
      optional(:token).maybe()
      optional(:page).maybe()
    end

    def call(params)
      page = params[:page] ? params[:page].to_i : 1

      projectRepository = ProjectRepository.new
      count = @user.projects_num
      projects = @user.projects(page: page)

      back_projects = []
      projects.each do |project|
        image_url = project.image_url[0] == '/' ? "http://192.168.31.208" + project.image_url : project.image_url
        back_project = {id: project.id, name: project.name, image: image_url, state: project.state}
        back_projects << back_project
      end

      self.body = {
        count: count,
        projects: back_projects
      }.to_json
    end
  end
end
