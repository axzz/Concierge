class SmsService
  attr_reader :error

  def initialize(tel, type = :web_login)
    @error = 'Invaild Telphone Number' unless tel =~ /^1[34578]\d{9}$/
    @tel = tel
    @type = type
  end

  def send_sms
    return false if @error
    if TEST
      code = '123456' # for test
    else
      code = Tools.make_random_string
      res = Aliyun::Sms.send(@tel, 'SMS_117390014', { 'code' => code }.to_json, '').body
      res = JSON.parse(res)
      if res['Message'] != 'OK'
        @error = res['Message']
        return false
      end
    end
    Redis.new.set(key, code, ex: 600)
  end

  def verify_sms(code)
    Redis.new.get(key) == code ? Redis.new.del(key) : false
  end

  private

  # get key of redis
  def key
    "#{@tel}.#{@type}"
  end
end
