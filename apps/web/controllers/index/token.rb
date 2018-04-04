module Web::Controllers::Index
  class Token
    include Web::Action
    def call(params)
      error={error: "Invalid Params"}.to_json
      halt 422, error unless params[:code]
      halt 422, error unless params[:tel] =~ /^1[34578]\d{9}$/
      halt 422, error unless user=UserRepository.new.find_user_by_tel(params[:tel])
      halt 422, error unless verify_SMS(params[:tel],params[:code])

      token=Tools.make_token(user.id)
      self.headers.merge!({'Authorization' => token})
      self.body=""
    end

    def verify_SMS(tel,code)
      Redis.new.get("#{tel}.code")==code ? Redis.new.del("#{tel}.code") : false
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end