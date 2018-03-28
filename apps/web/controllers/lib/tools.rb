class Tools
    TOKEN_SECRET="skylark_$ecret_token_2018"
    def self.make_token(id)
        payload = { id: id, exp: Time.now.to_i+3600*36}
        JWT.encode payload,TOKEN_SECRET,'HS256',{ typ: 'JWT' }
    end

    def self.parse_token(token)
        begin
            decoded_token = JWT.decode token, TOKEN_SECRET, true, { algorithm: 'HS256' }
            return "success",decoded_token[0]["id"]
        rescue JWT::ExpiredSignature
            return "token expired"
        rescue JWT::DecodeError
            return "error token"
        end        
    end
end