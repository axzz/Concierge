module MiniprogramAdmin::Controllers::Index
  class Sms
    include MiniprogramAdmin::Action

    def call(params)
      tel = params[:tel]
      repository = UserRepository.new
      halt 403,'Tel have been used' if repository.find_by_tel(tel)
      repository.create(tel: tel, name: (params[:name]))
      sms_service = SmsService.new(tel, 'sign_admin')
      if sms_service.send_sms
        self.body = ''
      else
        halt 400, { error: sms_service.error }.to_json
      end
    end
  end
end
