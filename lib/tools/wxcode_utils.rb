require 'net/http'
require 'base64'

class WxcodeUtils
  ACCESS_URI = URI("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{APP_ID}&secret=#{APP_SECRET}")
  WXCODE_URI = 'https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token='
  PROJECT_PAGE = 'pages/introduce/introduce'
  
  def self.access_token
    token = Redis.new.get('access_token')
    unless token
      response = JSON.parse(Net::HTTP.get(ACCESS_URI))
      raise RuntimeError if response['errcode']
      token = response['access_token']
      expire = response['expires_in']
      Redis.new.set('access_token', token, ex: (expire - 300))
    end
    token
  end

  def self.make_share_project_wxcode(project_id)
    wxcode = require_wxcode(project_id)
    save_wxcode(project_id, wxcode)
    "/wxcode/wxcode_#{project_id}.png"
  end

  private

  def self.require_wxcode(project_id)
    uri = URI(WXCODE_URI + access_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = { scene: project_id.to_s, page: PROJECT_PAGE }.to_json
    http.request(req).body
  end

  def self.save_wxcode(project_id, wxcode)
    path = "public/wxcode/wxcode_#{project_id}.png"
    file = File.new(path, 'a')
    file.binmode
    file.write(wxcode)
    file.close
  end
end
