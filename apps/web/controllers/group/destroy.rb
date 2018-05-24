module Web::Controllers::Group
  class Destroy
    include Web::Action

    params do
      optional(:token).maybe(:str?)
      required(:id).filled(:int?)
    end

    def call(params)
      group_repository = GroupRepository.new
      group = group_repository.find(params[:id])
      group_repository.delete(group.id) if group.creator_id == @user.id
      halt 201
    end
  end
end
