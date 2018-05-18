module Web::Controllers::Index
  # redirect '/' to '/index.html'
  class Index
    include Web::Action
    def call(_params)
      self.format = :html
      redirect_to '/index.html'
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
