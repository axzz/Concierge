module Web::Controllers::Group
  class Create
    include Web::Action

    handle_exception ArgumentError => 422

    params do
      optional(:token).maybe(:str?)
      required(:name).filled(:str?)
      required(:projects).filled
    end

    def call(params)
      group = GroupRepository.new.create(creator_id: @user.id,
                                         name: params[:name])
      group.add_projects(params[:projects])
      path = WxcodeUtils.make_group_wxcode(group.id)
      GroupRepository.new.update(group.id, wx_code: path)
      halt 201
    end
  end
end
