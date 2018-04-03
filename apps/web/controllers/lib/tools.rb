class Tools
    TOKEN_SECRET="skylark_$ecret_token_2018"
    def self.make_token (id)
        payload = { id: id, exp: Time.now.to_i+3600*36}
        JWT.encode(payload, TOKEN_SECRET, 'HS256', { typ: 'JWT' })
    end

    def self.parse_token (token)
        begin
            decoded_token = JWT.decode(token, TOKEN_SECRET, true, {algorithm: 'HS256'})
            return "success", decoded_token[0]["id"]
        rescue JWT::ExpiredSignature
            return "token expired"
        rescue JWT::DecodeError
            return "error token"
        end        
    end

    def self.make_random_string (char_list: ("0".."9").to_a, length: 6)
        string = ""
        1.upto(length) { |i| string << char_list[rand(char_list.size-1)] }
        return string
    end


    def self.parse_time_state (time_state)
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
                raise "Fail in parse limit" unless period["limit"].class == Fixnum
                time_state_parsed[day.to_sym] << {time: period["time"],limit: period["limit"]}
            end
        end
        time_state_parsed[:Special] = time_state["special"]
    
        time_state_parsed.each do |key,value|
            time_state_parsed[key] = value.sort {|a, b|  a[:time] <=> b[:time] }
        end
        time_state_parsed
    end

    def self.prevent_frequent_submission (id: "0", method: "all", interval: 1000)
        redis = Redis.new
        fobbiden = redis.get ('#{id}.#{method}')
        return "halt" if fobbiden
        redis.set '#{id}.#{method}','on use'
        redis.pexpire '#{id}.#{method}',interval
        return 
    end
end
