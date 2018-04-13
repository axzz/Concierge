module Web
    module Headermaker
        def self.included(action)
            action.class_eval do
                before :make_header
            end
        end

        private

        def make_header
            self.headers.merge!({'Access-Control-Expose-Headers'=>'Authorization'})
            self.headers.merge!({'Access-Control-Allow-Methods'=>'POST, GET, HEAD, OPTIONS, PUT'})
            self.headers.merge!({'Access-Control-Allow-Origin' => '*'})
            self.headers.merge!({'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, X-Custom-Header, Authorization' })
            self.headers.merge!({'Access-Control-Max-Age' => '1728000'})
            self.format= :json
        end
    end
end
