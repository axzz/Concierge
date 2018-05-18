module Web::Controllers::Index
  # First token get
  class Token
    include Web::Action
    params do
      required(:tel).filled(:str?)
      required(:code).filled(:str?)
    end

    handle_exception ArgumentError => 422
    
    def call(params)
      halt 422, { error: 'Invalid params' }.to_json unless params.valid?
      user = UserRepository.new.find_by_tel(params[:tel])
      halt 422, { error: 'No such user' }.to_json unless user

      result = SmsService.new(params[:tel]).verify_sms(params[:code])
      halt 422, { error: 'Invalid params in code' }.to_json unless result

      new_token = Tools.make_jwt(user.id)
      headers['Authorization'] = new_token
      self.body = { name: user.name }.to_json
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
