Aliyun::Sms.configure do |config|
    config.access_key_secret = 'KwrQlRgz0HC2sreRpen7RH127IQFte'
    config.access_key_id = 'LTAI5OoDTeOSDvdZ'           
    config.action = 'SendSms'                       # default value
    config.format = 'JSON'                           # http return format, value is 'JSON' or 'XML'
    config.region_id = 'cn-hangzhou'                # default value      
    config.sign_name = '了了科技'                
    config.signature_method = 'HMAC-SHA1'           # default value
    config.signature_version = '1.0'                # default value
    config.version = '2017-05-25'                   # default value
  end