module Web::Controllers::Index
  class Option
    include Web::Action

    def call(params)
      self.headers.merge!({'Access-Control-Allow-Methods'=>'POST, GET, HEAD, OPTIONS, PUT'})
      self.headers.merge!({'Access-Control-Allow-Origin' => '*'})
      self.headers.merge!({'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, X-Custom-Header' })
      self.headers.merge!({'Access-Control-Max-Age' => 1728000})
      self.body=""
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end

    def make_header
      #登录页跳过权限判断中间件
    end
  end
end
