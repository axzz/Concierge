module Web::Controllers::Index
  class Index
    include Web::Action

    def call(params)
      self.format = :html
      redirect_to '/index.html'
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
