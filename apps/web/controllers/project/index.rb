module Web::Controllers::Project
  class Index
    include Web::Action

    expose :count, :projects

    params do
      optional(:token).maybe
      optional(:page).maybe
    end

    def call(params)
      page = params[:page] || 1
      page = page.to_i > 0 ? page.to_i : 1

      @count = @user.projects_num
      @projects = @user.projects(page: page)
    end
  end
end
