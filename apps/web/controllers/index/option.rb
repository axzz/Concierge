module Web::Controllers::Index
  class Option
    include Web::Action

    def call(params)
      self.headers.merge!({'Access-Control-Max-Age' => "1728000"})
      self.body = ""
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end
