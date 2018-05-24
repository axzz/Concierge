module Web::Controllers::Project
  class Index
    include Web::Action

    expose :count, :projects

    params do
      optional(:token).maybe
      optional(:page).maybe
      optional(:group).maybe
      optional(:size).maybe
    end

    def call(params)
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      size = params[:size].to_i > 0 ? params[:size].to_i : 12

      if params[:group]
        group = GroupRepository.new.find(params[:group].to_i)
        halt 404 unless group
        halt 401 unless group.creator_id == @user.id
        @count = group.total
        @projects = group.projects(page, size)
      else
        @count = @user.projects_num
        @projects = @user.projects(page: page, size: size)
      end
    end
  end
end
