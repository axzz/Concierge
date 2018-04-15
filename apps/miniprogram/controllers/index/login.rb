module Miniprogram::Controllers::Index
  class Login
    include Miniprogram::Action

    params do
      required(:code).filled(:str?)
    end

    def call(params)
      halt 422 unless params.valid?
      url = get_url(params[:code])
      html_response = nil
      open(url) { |http| html_response = http.read }
      begin
        openid = JSON.parse(html_response)[:openid]
      rescue StandardError
        halt 400, 'Invaild code'
      end
      token = get_token(openid)
      self.body = { token: token }.to_json
    end

    def get_url(code)
      appid = 'wxd6d2d2ba6ca5b4ba'
      secret = '90ba8c9320ee3b3acab58d4873343029'

      'https://api.weixin.qq.com/sns/jscode2session?' \
      "appid=#{appid}&" \
      "secret=#{secret}&" \
      "js_code=#{code}&" \
      'grant_type=authorization_code'
    end

    def get_token(openid)
      # find user
      repository = UserRepository.new
      user = repository.find_by_openid(openid)
      user ||= repository.create(openid: openid)

      Tools.make_miniprogram_token(user.id)
    end
  end
end
