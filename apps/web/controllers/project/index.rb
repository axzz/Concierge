module Web::Controllers::Project
  class Index
    include Web::Action

    params do
      optional(:token).maybe()
      optional(:page).maybe()
    end

    def call(params)
      if params[:page]
        page=params[:page].to_i
      else
        page=1
      end
      projectRepository=ProjectRepository.new
      count=projectRepository.get_count @user.id
      projects=projectRepository.get_list @user.id,page
      back_projects=[]
      projects.each do |project|
        back_project={id: project.id,name: project.name,image: project.image_url,state: project.state}
        back_projects << back_project
      end
      self.status=200
      self.body={
        count: count,
        projects: back_projects
      }.to_json

    end
  end
end
