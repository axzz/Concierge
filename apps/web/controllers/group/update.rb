module Web::Controllers::Group
  class Update
    include Web::Action

    handle_exception ArgumentError => 401

    params do
      optional(:token).maybe(:str?)
      required(:name).filled(:str?)
      required(:projects).filled
    end
    
    def call(params)
      group = GroupRepository.new.find(params[:id].to_i)
      group.clear
      GroupRepository.new.update(group.id, name: params[:name])
      group.add_projects(params[:projects])
      halt 201
    end
  end
end
