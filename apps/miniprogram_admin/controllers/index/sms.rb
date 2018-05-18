module MiniprogramAdmin::Controllers::Index
  class Sms
    include MiniprogramAdmin::Action
    handle_exception ArgumentError => 422

    def call(params)
      tel = params[:tel]
      repository = UserRepository.new
      halt 403, 'Already manager' if @user.manager?
      halt 403, 'Telephone number have been used' if repository.find_by_tel(tel)

      sms_service = SmsService.new(tel, 'sign_admin')
      halt 400, { error: sms_service.error }.to_json unless sms_service.send_sms
      self.body = ''
    end
  end
end
