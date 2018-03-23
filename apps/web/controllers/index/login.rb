require 'json'


module Web::Controllers::Index
  class Login
    include Web::Action

    def call(params)
      #Test1.new.test()
      self.format=:json
      if params[:tel].nil?
        self.body={state: 'fail',reason: '没有填写手机号码'}.to_json
      elsif !(params[:tel] =~ /^1[34578]\d{9}$/)
        self.body={state: 'fail',reason: '手机号不符规范'}.to_json
      else
        @repository=UserRepository.new
        tel=params[:tel]
        @user=@repository.create(tel: tel,name: ('管理员'+tel[-4..-1])) unless @user=@repository.find_user_by_tel(tel)
        if params[:code].nil?
          #请求短信服务
          state,reason=SMS_service(tel)
          self.body={state: state,reason: reason}.to_json
        else
          #请求验证服务
          reason=verify_SMS_service(params[:code])
          if reason==""
            token=make_token()
            limit_time=Time.now+3600*36
            @repository.update(@user.id,token: token,token_limit: limit_time,SMS_limit: (Time.now-1))
            self.body={state: "success",token: token}.to_json
          else
            self.body={state: "fail",reason: reason}.to_json
          end
        end
      end
    end

    def SMS_service (tel)
      #生成code，发送短信
      code=make_SMS
      Aliyun::Sms.send(tel, 'SMS_117390014', {'code'=> code}.to_json, '')
      #code="123456"
      @repository.update(@user.id,SMS: code,SMS_limit: (Time.now+600))
      return "success",""
    end

    def verify_SMS_service(code)
      if @user.SMS!=code
        return "验证码输入错误"
      elsif Time.now>@user.SMS_limit
        return "短信已过期"
      end
      return ""
    end

    def make_SMS
      chars =("0".."9").to_a
      code=""
      1.upto(6) { |i| code << chars[rand(chars.size-1)] }
      return code
    end

    def make_token
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      token = ""
      1.upto(32) { |i| token << chars[rand(chars.size-1)] }
      return token
    end

    def authenticate!
      self.headers.merge!({ 'Access-Control-Allow-Origin' => '*','Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept' })
      #登录页跳过权限判断中间件
    end
  end
end
