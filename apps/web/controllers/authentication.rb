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
            self.headers.merge!({ 'Access-Control-Allow-Origin' => 'http://192.168.31.228:8080','Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept' })
            self.format= :json

            token=params[:token] unless token=request.env["HTTP_AUTHORIZATION"]
            state,id=Tools.parse_token(token)
            unless state=="success"
                halt 401,state
            end
            @user=UserRepository.new.find(id)
        end
    end
end