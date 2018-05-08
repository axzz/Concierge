module Web::Controllers::Index
  class Index
    include Web::Action

    def call(params)
      self.headers.merge!({ 'Content-Security-Policy' => "default-src 'self' webapi.amap.com; script-src 'self' webapi.amap.com ; style-src * 'unsafe-inline' ; font-src 'self' data:" })
      self.format = :html
      redirect_to '/index.html'
    end

    private

    def authenticate!
      # skip auth
    end

  end
end
