module Web::Controllers::Project
  class All
    include Web::Action

    expose :projects

    def call(params)
      @projects = @user.projects(page: 1, size: 10_000)
    end
  end
end
