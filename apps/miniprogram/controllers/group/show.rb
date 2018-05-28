module Miniprogram::Controllers::Group
  class Show
    include Miniprogram::Action

    expose :group

    def call(params)
      @group = GroupRepository.new.find(params[:id])
      halt 404 unless @group
    end
  end
end
