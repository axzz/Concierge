module MiniprogramAdmin::Controllers::Index
  class Login
    include MiniprogramAdmin::Action

    def call(params)
      halt 422, { error: 'Invalid params' }.to_json unless params.valid?

      result = SmsService.new(params[:tel],'sign_admin').verify_sms(params[:code])
      halt 422, { error: 'Invalid params in code' }.to_json unless result

      UserRepository.new.update(@user.id, tel: params[:tel], name: params[:name])
      self.body = ''
    end
  end
end
