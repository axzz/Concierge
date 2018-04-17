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
      user = find_user(openid)
      token = Tools.make_miniprogram_token(user.id)
      role = user.tel ? 'manager' : 'customer'
      self.body = { token: token, role: role }.to_json
    end

    private

    def get_url(code)
      appid = 'wxd6d2d2ba6ca5b4ba'
      secret = '90ba8c9320ee3b3acab58d4873343029'

      'https://api.weixin.qq.com/sns/jscode2session?' \
      "appid=#{appid}&" \
      "secret=#{secret}&" \
      "js_code=#{code}&" \
      'grant_type=authorization_code'
    end

    def find_user(openid)
      repository = UserRepository.new
      repository.find_by_openid(openid) || repository.create(openid: openid)
    end
  end
end
