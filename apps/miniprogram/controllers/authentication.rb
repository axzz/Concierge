require 'json'
import './lib/test1'

module Miniprogram
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :user
      end
    end

    private

    def authenticate! (params)
      token = params[:token] unless token = request.env["HTTP_AUTHORIZATION"]
      begin
        id = Tools.parse_token(token)
      rescue
        halt 401, "Invalid Token"
      end
      @user = UserRepository.new.find(id)
      halt 401, "No User" unless @user
	  end
  end
end
