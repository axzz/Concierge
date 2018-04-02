module Web::Controllers::Index
  class Sms
    include Web::Action

    def call(params)
      halt 403,{error: 'Invalid Params'}.to_json unless params[:tel] =~ /^1[34578]\d{9}$/
      
      tel=params[:tel]
      repository=UserRepository.new
      repository.create(tel: tel,name: ('管理员'+tel[-4..-1])) unless repository.find_user_by_tel(tel)

      halt 403,{error: error}.to_json if error=SMS_service(tel)
      self.body=""
    end
      
    def SMS_service (tel)
        #生成code，发送短信
        #code=make_SMS
        #res=Aliyun::Sms.send(tel, 'SMS_117390014', {'code'=> code}.to_json, '')
        #return "发送短信出现错误" unless res["Message"]=="OK"
        code="123456" #for test
        redis=Redis.new
        redis.set(tel+".code",code)
        redis.expire(tel+".code",600)
        return
    end

    def make_SMS
      chars = ("0".."9").to_a
      code = ""
      1.upto(6) { |i| code << chars[rand(chars.size-1)] }
      return code
    end

    def authenticate!
        #登录页跳过权限判断中间件
    end
  end
end
