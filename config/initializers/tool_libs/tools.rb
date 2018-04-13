class Tools
  TOKEN_SECRET="0rder_$ecret_token_2018"
  def self.make_token (id)
    payload = { id: id, exp: Time.now.to_i+3600*36 }
    JWT.encode(payload, TOKEN_SECRET, 'HS256', { typ: 'JWT' })
  end

  def self.parse_token (token)
    decoded_token = JWT.decode(token, TOKEN_SECRET, true, {algorithm: 'HS256'})
    return decoded_token[0]["id"]
  end

  def self.make_random_string (char_list: ("0".."9").to_a, length: 6)
    string = ""
    1.upto(length) { |i| string << char_list[rand(char_list.size-1)] }
    string
  end

  def self.prevent_frequent_submission (id: "0", method: "all", interval: 1000)
    redis = Redis.new
    fobbiden = redis.get (key(id, method))
    return false if fobbiden
    redis.set(key(id, method), 'on use', px: interval)
    return true
  end

  def self.key(id, method)
    '#{id}.#{method}'
  end
end

class Date
  @@holidays = JSON.parse(File.read("#{Hanami.root}/lib/app/holiday_data.json"))
  
  def holiday?
    @@holidays.include?(self.to_s)
  end
end