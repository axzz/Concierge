# 负责短信发送

module Web::Controllers::Index
  class Sms
    include Web::Action

    def call(params)
      halt 422, {error: 'Invalid Params'}.to_json unless params[:tel] =~ /^1[34578]\d{9}$/
      
      tel = params[:tel]
      repository = UserRepository.new
      repository.create(tel: tel, name: ('管理员'+tel[-4..-1])) unless repository.find_by_tel(tel)

      sms_service = SmsService.new(tel)
      if sms_service.send_sms
        self.body=""
      else
        halt 400, {error: sms_service.error}.to_json
      end
    end

    private
    
    def authenticate!
        #登录页跳过权限判断中间件
    end
  end
end
