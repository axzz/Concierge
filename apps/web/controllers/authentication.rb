module Web
  module Authentication
    # Get @user and refresh token
    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :user
      end
    end

    private

    def authenticate!(params)
      token = request.env['HTTP_AUTHORIZATION'] || params[:token]
      begin
        id = Tools.parse_token(token)
      rescue StandardError
        halt 401, 'Invalid Token'
      end
      new_token = Tools.make_jwt(id)
      headers['Authorization'] = new_token
      @user = UserRepository.new.find(id)
      halt 401, 'No User' unless @user
      halt 403, 'No Permission' unless @user.manager?
    end
  end
end
