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

    def self.parse_time_state time_state
        time_state_parsed={
            Mon: [],
            Tues: [],
            Wed: [],
            Thur: [],
            Fri: [],
            Sat: [],
            Sun: [],
            Holiday: [],
            Special: []
        }
        time_state["normal"].each do |period|
            period["weekday"].each do |day|
                raise "Fail in parse time" unless period["time"] =~ /\d{2}:\d{2}-\d{2}:\d{2}/
                raise "Fail in parse limit" unless period["limit"].class==Fixnum
                time_state_parsed[day.to_sym]<<{time: period["time"],limit: period["limit"]}
            end
        end    
        time_state_parsed[:Special]=time_state["special"]
    
        time_state_parsed.each do |key,value|
            value=value.sort do |a, b|  
                a[:time]<=>b[:time]
            end
            time_state_parsed[key]=value
        end
        time_state_parsed
    end

    def self.prevent_frequent_submission (id: "0", method: "all",interval: 10)
        redis=Redis.new
        fobbiden = redis.get (id + "." + method)
        half 403,({error: "Too Quick"}.to_json) if fobbiden
        redis.set id+"."+method , "on use"
        redis.pexpire id+"."+method,interval*1000
    end
end