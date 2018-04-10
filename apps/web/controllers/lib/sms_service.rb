class SmsService
  def initialize(tel)
    @error = "Invaild Telphone Number" unless tel =~ /^1[34578]\d{9}$/
    @tel = tel
  end

  def error
    @error
  end

  def send_sms
    return false if @error
    # 生成code，发送短信
    # code = Tools.make_random_string()
    # res = Aliyun::Sms.send(@tel, 'SMS_117390014', {'code'=> code}.to_json, '')
    # if res.body["OK"] != "OK"
    #   @error = "Error in sending sms" 
    #   return false
    # end
    # TODO (L):parse response
    
    code = "123456" # for test
    redis = Redis.new
    redis.set(key, code, ex: 600)
    true
  end

  def verify_sms(code)
    Redis.new.get(key) == code ? Redis.new.del(key) : false
  end

  private

  # 存储短信所用的redis键
  def key
    "#{@tel}.code"
  end
end