module Miniprogram::Controllers::Index
  class Login
    include Miniprogram::Action

    params do
      required(:code).filled(:str?)
    end

    def call(params)
      halt 422 unless params.valid?
      appid = "wxd6d2d2ba6ca5b4ba"
      secret = "90ba8c9320ee3b3acab58d4873343029"
      code = params[:code]

      url = "https://api.weixin.qq.com/sns/jscode2session?appid=#{appid}&secret=#{secret}&js_code=#{code}&grant_type=authorization_code"

      html_response = nil 
      open(url) { |http|  html_response = http.read }
      begin
        openid = JSON.parse(html_response)[:openid]
      rescue
        halt 400
      end

      # find user
      repository = UserRepository.new
      user = repository.create(openid: openid) unless user = repository.find_by_openid(openid)
      # 唯一指定登录界面
      
      # get token
      token = Tools.make_miniprogram_token(user.id)

      self.body = { token: token }.to_json
    end
  end
end
