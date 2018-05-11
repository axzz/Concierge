require 'net/http'

class WxcodeUtils
  ACCESS_URI = URI("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{APP_ID}&secret=#{APP_SECRET}")

  WXCODE_URI = "https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token="
  PROJECT_PAGE = ''
  def self.access_token
    token = Redis.new.get('access_token')
    unless token
      response = JSON.parse(Net::HTTP.get(ACCESS_URI))
      raise RuntimeError if response[:errcode]
      token = response[:access_token]
      expire = response[:expires_in]
      Redis.new.set('access_token',token,ex: (expire - 300))
    end
    token
  end

  def self.make_share_project_wxcode(project_id)
    response = Net:HTTP.post(WXCODE_URI,{ scene: project_id, page: PROJECT_PAGE }.to_json)
    # save picture data stream
  end
end