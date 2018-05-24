require 'net/http'
require 'base64'
require 'digest'


class WxcodeUtils
  ACCESS_URI = URI("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{APP_ID}&secret=#{APP_SECRET}")
  WXCODE_URI = 'https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token='
  PROJECT_PAGE = 'pages/introduce/introduce'
  GROUP_PAGE = 'pages/group/group'
  REGIST_PAGE = 'pages/regist/regist'

  
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
    wxcode = require_wxcode(project_id, PROJECT_PAGE)
    name = Digest::MD5.hexdigest("wxcode_#{project_id}")
    path = "/wxcode/#{name}.png"
    save_wxcode(path, wxcode)
    path
  end

  def self.make_group_wxcode(group_id)
    wxcode = require_wxcode(group_id, GROUP_PAGE)
    name = Digest::MD5.hexdigest("group_#{group_id}")
    path = "/wxcode/#{name}.png"
    save_wxcode(path, wxcode)
    path
  end

  def self.make_register_wxcode
    wxcode = require_wxcode('1', REGIST_PAGE)
    path = '/wxcode/regist.png'
    save_wxcode(path, wxcode)
    path
  end

  private

  def self.require_wxcode(data, page)
    uri = URI(WXCODE_URI + access_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = { scene: data.to_s, page: page }.to_json
    http.request(req).body
  end

  def self.save_wxcode(path, wxcode)
    path = "public" << path
    file = File.new(path, 'a')
    file.binmode
    file.write(wxcode)
    file.close
  end
end
