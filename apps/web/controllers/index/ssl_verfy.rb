module Web::Controllers::Index
  class SslVerfy
    include Web::Action

    def call
      path = './public/.well-known/acme-challenge' + request.path_info
      file = ::File.open(path, 'r')
      line = file.gets
      self.body = line
    end

    def authenticate!
      # skip auth
    end
  end
end
