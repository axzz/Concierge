module Web::Controllers::Index
  class Token
    include Web::Action
    params do
      required(:tel).filled(:str?)
      required(:code).filled(:str?)
    end

    def call(params)
      halt 422, { error: 'Invalid params' }.to_json unless params.valid?
      user = UserRepository.new.find_by_tel(params[:tel])
      halt 422, { error: 'No such user' }.to_json unless user

      result = SmsService.new(params[:tel]).verify_sms(params[:code])
      halt 422, { error: 'Invalid params in code' }.to_json unless result

      new_token = Tools.make_token(user.id)
      headers['Authorization'] = new_token
      self.body = ''
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
