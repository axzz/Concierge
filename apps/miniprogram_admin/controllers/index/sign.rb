module MiniprogramAdmin::Controllers::Index
  class Sign
    include MiniprogramAdmin::Action

    params do
      required(:name).filled(:str?)
      required(:tel).filled(:str?)
    end

    def call(params)
      halt 422 unless params.valid?
      halt 422 unless verify_sms(params)

      UserRepository.new.update(@user.id, tel: params[:tel], name: params[:name])
      self.body = ''
    end

    def verify_sms(params)
      SmsService.new(params[:tel], 'sign_admin')
                .verify_sms(params[:code])
    end
  end
end
