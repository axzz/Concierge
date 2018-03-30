module Web::Controllers::Project
  class Index
    include Web::Action

    def call(params)
      projects=ProjectRepository.new.get_list user
    end
  end
end
