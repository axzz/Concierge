module Web::Controllers::Index
  class Token
    include Web::Action
    params do
      required(:tel).filled(:str?)
      required(:code).filled(:str?)
    end

    def call(params)
      halt 422, { error: "Invalid params in basic" }.to_json unless params.valid?
      halt 422, { error: "No such user" }.to_json unless user = UserRepository.new.find_by_tel(params[:tel])
      halt 422, {error: "Invalid params in code"}.to_json unless SmsService.new(params[:tel]).verify_sms(params[:code])

      token=Tools.make_token(user.id)
      self.headers.merge!({'Authorization' => token})
      self.body = ''
    end

    private

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end
