module Web::Controllers::Index
  class Token
    include Web::Action

    def call(params)
      error={error: 'Invalid Params'}.to_json
      halt 403,error unless params[:code]
      halt 403,error unless params[:tel] =~ /^1[34578]\d{9}$/
      halt 403,error unless user=UserRepository.new.find_user_by_tel(params[:tel])
      halt 403,error if verify_SMS_service(params[:tel],params[:code])

      token=Tools.make_token(user.id)
      self.headers.merge!({'Authorization' => token})
      self.body=""
    end

    def verify_SMS_service(tel,code)
      if Redis.new.get(tel+".code")!=code
        return 'Invalid Params'
      else
        Redis.new.del(tel+".code")
        return
      end
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end
