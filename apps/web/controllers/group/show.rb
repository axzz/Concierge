module Web::Controllers::Group
  class Show
    include Web::Action

    expose :projects, :group
    def call(params)
      @group = GroupRepository.new.find(params[:id])
      halt 404 unless @group
      halt 401 if @user.id != @group.creator_id
      @projects = group.projects.to_a
    end
  end
end
