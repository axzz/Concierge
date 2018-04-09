module Web::Controllers::Index
  class Token
    include Web::Action
    def call(params)
      error={error: "Invalid Params"}.to_json
      
      halt 422, error unless params[:code]
      halt 422, error unless params[:tel] =~ /^1[34578]\d{9}$/
      halt 422, error unless user = UserRepository.new.find_by_tel(params[:tel])
      halt 422, {error: "Invalid Params in code"}.to_json unless SmsService.new(params[:tel]).verify_sms(params[:code])

      token=Tools.make_token(user.id)
      self.headers.merge!({'Authorization' => token})
      self.body = ''
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end