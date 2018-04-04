module Web::Controllers::Index
  class Sms
    include Web::Action

    def call(params)
      halt 422, {error: 'Invalid Params'}.to_json unless params[:tel] =~ /^1[34578]\d{9}$/
      
      tel = params[:tel]
      repository = UserRepository.new
      repository.create(tel: tel, name: ('管理员'+tel[-4..-1])) unless repository.find_user_by_tel(tel)

      halt 400, {error: error}.to_json if error = SMS_service(tel)
      self.body=""
    end
      
    def SMS_service (tel)
        # 生成code，发送短信
         code = Tools.make_random_string()
         res = Aliyun::Sms.send(tel, 'SMS_117390014', {'code'=> code}.to_json, '')
         return "error in send sms" if res.body["OK"] != "OK"
        # TODO (L):parse response

        # code = "123456" #for test
        redis = Redis.new
        redis.set(tel + ".code", code)
        redis.expire(tel + ".code", 600)
        return
    end

    def authenticate!
        #登录页跳过权限判断中间件
    end
  end
end
