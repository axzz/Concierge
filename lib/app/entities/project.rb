require_relative '../image_uploader'
class Project < Hanami::Entity
    include ImageUploader[:image]

    def get_image_url
        if self.default_image
            return self.default_image
        elsif self.image_url()
            return self.image_url()
        else
            return "/cover/default.jpg"
        end
    end
end
