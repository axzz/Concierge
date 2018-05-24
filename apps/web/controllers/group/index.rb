module Web::Controllers::Group
  class Index
    include Web::Action

    expose :groups

    def call(_params)
      @groups = GroupRepository.new.get_groups(@user.id).to_a
    end
  end
end
