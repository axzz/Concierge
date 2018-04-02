require 'json'
import './lib/test1'

module Web
    module Authentication
        def self.included(action)
            action.class_eval do
                before :authenticate!
                expose :user
            end
        end

    private
        def authenticate! (params)
            token=params[:token] unless token=request.env["HTTP_AUTHORIZATION"]
            state,id=Tools.parse_token(token)
            unless state=="success"
                halt 401,state
            end
            new_token=Tools.make_token(id)
            self.headers.merge!({'Authorization'=>new_token})
            @user=UserRepository.new.find(id)
            halt 401,"no user" unless @user
	end
    end
end
