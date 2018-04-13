module Web::Controllers::Index
  class UploadImage
    include Web::Action
    params do
      optional(:token).maybe(:str?)
      optional(:tag).filled(:str?)
      required(:image).filled()
    end

    def call(params)
      halt 422, ({ error: "Invalid Params" }.to_json) unless params.valid?
      imagefile = ::File.open(params[:image][:tempfile])
      tag = params[:tag] || "uploads"
      image = Image.new(tag: tag, image: imagefile)
      image = ImageRepository.new.create(image)
      self.body = { image: image.image_url }.to_json
    end
  end
end
