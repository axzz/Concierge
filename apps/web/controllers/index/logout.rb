module Web::Controllers::Index
  class Logout
    include Web::Action

    def call(params)
      UserRepository.new.logout(params[:tel])
      self.body={state: 'success',reason: '成功退出登录'}.to_json
    end
  end
end
