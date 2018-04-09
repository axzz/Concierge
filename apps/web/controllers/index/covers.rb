module Web::Controllers::Index
  class Covers
    include Web::Action
    def call(params)
      self.body = { images: covers }.to_json
    end

    def covers
      Dir["./public/static/images/*"].sort[0..8].each { |str| str['./public'] = '' }
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end
