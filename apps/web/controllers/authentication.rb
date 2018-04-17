module Web
  module Authentication
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
      new_token = Tools.make_token(id)
      headers['Authorization'] = new_token
      @user = UserRepository.new.find(id)
      halt 401, 'No User' unless @user
    end
  end
end
