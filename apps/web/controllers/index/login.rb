require 'json'

module Web::Controllers::Index
  class Login
    include Web::Action
    #完成文档 interface_login_V0.1
    #2018_3_14 By axzz
    def call(params)
      self.headers.merge!({ 'Access-Control-Allow-Origin' => 'http://192.168.31.228:8080','Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept' })
      if params[:tel].nil?
          self.body={state: 'fail',reason: '没有填写手机号码'}.to_json
      else
        if params[:code].nil?
          #请求短信服务
          state,reason=msg_service(params[:tel])
          self.body={state: state,reason: reason}.to_json
        else
          #请求验证服务
          token,reason=verify_service(params[:tel],params[:code])
          unless token==''
            #成功
            self.body={state: "success",token: token}.to_json
          else
            #失败
            self.body={state: "fail",reason: reason}.to_json
          end
        end
      end
    end

    def msg_service(tel)
      #判断tel合法性
      return "fail","手机号不符规范" unless (tel =~ /^1[34578]\d{9}$/ )

      #TODO: 生成code，发送短信
      code="123456"

      #存储tel、code
      repository=UserRepository.new
      repository.create(tel: tel,name: ('管理员'+tel[-4..-1])) unless repository.find_user_by_tel(tel)
      
      user_id=repository.find_user_by_tel(tel).id
      repository.update(user_id,SMS: code,SMS_limit: (Time.now+600))
      return "success",""
    end

    def verify_service(tel,code)
      #判断是否出错
      repository=UserRepository.new
      unless repository.find_user_by_tel(tel)
        return "","数据库内没有号码信息"
      end
      user=repository.find_user_by_tel_SMS(tel,code)
      if user.nil?
        return "","验证码输入错误"
      elsif Time.now>user.SMS_limit
        return "","短信已过期"
      end
      #生成token
      token=make_token
      limit_time=Time.now+3600*36
      #存储token，设定过期时间
      user_id=repository.find_user_by_tel(tel).id
      repository.update(user_id,token: token,token_limit: limit_time,SMS_limit: (Time.now-1))

      return token,""
    end

    def make_token
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      token = ""
      1.upto(32) { |i| token << chars[rand(chars.size-1)] }
      return token
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end
