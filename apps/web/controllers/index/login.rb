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
        self.body={error: '没有填写手机号码'}.to_json
      elsif !(params[:tel] =~ /^1[34578]\d{9}$/)
        self.status=403
        self.body={error: '手机号不符规范'}.to_json
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
            #redis=Redis.new
            #redis.set(tel+".token",token)
            #redis.expire(tel+".token",3600*36)
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
        return "验证码输入错误"
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

    #def make_token
    #  chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    #  token = ""
    #  1.upto(32) { |i| token << chars[rand(chars.size-1)] }
    #  return token
    #end

    def authenticate!
      self.headers.merge!({ 'Access-Control-Allow-Origin' => '*','Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept' })
      #登录页跳过权限判断中间件
    end
  end
end
