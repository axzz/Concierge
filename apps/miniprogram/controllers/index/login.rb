require 'net/http'

module Miniprogram::Controllers::Index
  class Login
    include Miniprogram::Action

    params do
      required(:code).filled(:str?)
    end

    def call(params)
      halt 422 unless params.valid?
      html_response = Net::HTTP.get(get_uri(params[:code]))
      begin
        openid = JSON.parse(html_response)['openid']
      rescue JSON::ParserError
        halt 400, 'Invaild code'
      end
      user = find_or_create_user(openid)
      token = Tools.make_miniprogram_jwt(user.id)
      self.body = { token: token, role: user.role }.to_json
    end

    private

    def get_uri(code)
      str = 'https://api.weixin.qq.com/sns/jscode2session?' \
      "appid=#{APP_ID}&"   \
      "secret=#{APP_SECRET}&" \
      "js_code=#{code}&"  \
      'grant_type=authorization_code'

      URI(str)
    end

    def find_or_create_user(openid)
      repository = UserRepository.new
      repository.find_by_openid(openid) ||
        repository.create(name: 'temp_custormer', openid: openid)
    end

    def authenticate!
      # skip auth
    end
  end
end
