require 'json'

module Web
    module Authentication
        def self.included(action)
            action.class_eval do
                before :authenticate!
            end
        end

    private

        def authenticate! (params)
            self.headers.merge!({ 'Access-Control-Allow-Origin' => 'http://192.168.31.228:8080','Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept' })
            unless UserRepository.new.verify_token(params[:tel],params[:token])
                halt 200,{state: 'fail',reason: 'no permission'}.to_json
            end
        end
    end
end