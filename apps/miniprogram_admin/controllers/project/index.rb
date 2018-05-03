module MiniprogramAdmin::Controllers::Project
  class Index
    include MiniprogramAdmin::Action

    expose :count, :projects
    params do
      optional(:token).maybe
      optional(:page).maybe
    end

    def call(params)
      halt 401 unless @user.manager?
      page = params[:page].to_i > 0 ? params[:page].to_i : 1

      @count = @user.projects_num
      @projects = @user.projects_miniprogram(page: page)
    end
  end
end
