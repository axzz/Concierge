require 'net/http'

module Miniprogram::Controllers::Index
  class Login
    include Miniprogram::Action

    params do
      required(:code).filled(:str?)
    end

    handle_exception JSON::ParserError => 400

    def call(params)
      halt 422 unless params.valid?
      response = Net::HTTP.get(login_uri(params[:code]))
      openid = JSON.parse(response)['openid']
      halt 422 unless openid
      user = find_or_create_user(openid)
      token = Tools.make_miniprogram_jwt(user.id)
      self.body = { token: token, role: user.role }.to_json
    end

    private

    def login_uri(code)
      URI('https://api.weixin.qq.com/sns/jscode2session?' \
          "appid=#{APP_ID}&"      \
          "secret=#{APP_SECRET}&" \
          "js_code=#{code}&"      \
          'grant_type=authorization_code')
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
