# 负责短信发送

module Web::Controllers::Index
  class Sms
    include Web::Action

    def call(params)
      tel = params[:tel]
      
      sms_service = SmsService.new(tel)
      if sms_service.send_sms
        self.body=""
      else
        halt 400, { error: sms_service.error }.to_json
      end
      
      repository = UserRepository.new
      repository.create(tel: tel, name: ('管理员'+tel[-4..-1])) unless repository.find_by_tel(tel)
    end

    private

    def authenticate!
        #登录页跳过权限判断中间件
    end
  end
end
