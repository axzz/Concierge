module Web::Controllers::Index
  class TestUploadImage
    include Web::Action

    def call(params)
      #params.each {|page| puts page}
      tempfile = params[:file][:tempfile]
      imagefile = ::File.open(tempfile)

      image = Image.new(image: imagefile)
      image = ImageRepository.new.create(image)

      self.body={image: image.image_url}.to_json
      puts image.image_url
      puts params[:name]
    end

    def authenticate!
      #登录页跳过权限判断中间件
    end
  end
end
