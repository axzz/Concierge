class Tools
  def self.make_jwt(id)
    payload = { id: id, exp: Time.now.to_i+3600*36 }
    JWT.encode(payload, TOKEN_SECRET, 'HS256', { typ: 'JWT' })
  end

  def self.make_miniprogram_jwt(id)
    payload = { id: id }
    JWT.encode(payload, TOKEN_SECRET, 'HS256', { typ: 'JWT' })
  end

  def self.parse_token(token)
    decoded_token = JWT.decode(token, TOKEN_SECRET, true, algorithm: 'HS256')
    decoded_token[0]['id']
  end


  def self.make_random_string(char_list: ('0'..'9').to_a, length: 6)
    string = ''
    1.upto(length) { string << char_list[rand(char_list.size - 1)] }
    string
  end

  def self.prevent_repeat_submit(id: '0', method: 'all', interval: 2000)
    return true if TEST
    redis = Redis.new
    fobbiden = redis.get(key(id, method))
    return false if fobbiden
    redis.set(key(id, method), 'on use', px: interval)
  end

  def self.key(id, method)
    "#{id}.#{method}"
  end
end
