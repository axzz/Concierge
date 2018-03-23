require_relative '../image_uploader'
class Project < Hanami::Entity
    include ImageUploader[:image]
end
