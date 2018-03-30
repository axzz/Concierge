require 'json'
import '../lib/tools'

module Web::Controllers::Index
  class Login
    include Web::Action

    def call(params)
      #Test1.new.test()
      self.format=:json
      if params[:tel].nil?
        self.status=403
        self.body={error: 'Invalid Params'}.to_json
      elsif !(params[:tel] =~ /^1[34578]\d{9}$/)
        self.status=403
        self.body={error: 'Invalid Params'}.to_json
      else
        tel=params[:tel]
        repository=UserRepository.new
        user=repository.create(tel: tel,name: ('管理员'+tel[-4..-1])) unless user=repository.find_user_by_tel(tel)
        if params[:code].nil?
          #请求短信服务
          state,error=SMS_service(tel)
          if state=="success"
            self.body=""
          else
            self.status=403
            self.body={error: error}.to_json
          end
        else
          #请求验证服务
          error=verify_SMS_service(tel,params[:code])
          if error==""
            token=Tools.make_token(user.id)
            Redis.new.del(tel+".code")
            self.headers.merge!({'Authorization' => token})
            self.body=""
          else
            self.status=403
            self.body={error: error}.to_json
          end
        end
      end
    end

    def SMS_service (tel)
      #生成code，发送短信

      #code=make_SMS
      #res=Aliyun::Sms.send(tel, 'SMS_117390014', {'code'=> code}.to_json, '')
      #return "fail","发送短信出现错误" unless res["Message"]=="OK"
      code="123456" #for test
      redis=Redis.new
      redis.set(tel+".code",code)
      redis.expire(tel+".code",600)
      
      return "success",""
    end

    def verify_SMS_service(tel,code)
      if Redis.new.get(tel+".code")!=code
        return "Invalid Params"
      else
        return ""
      end
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
