module Web::Controllers::Index
  class UploadImage
    include Web::Action
    def call(params)
      self.body = 'OK'
    end
  end
end
