# 处理用户的所有 OPTIONs 请求

module Web::Controllers::Index
  class Option
    include Web::Action

    def call(params)
      self.body = ''
    end

    private
    
    def authenticate!
      # 登录页跳过权限判断中间件
    end
  end
end
