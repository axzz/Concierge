require_relative '../image_uploader'

class ProjectRepository < Hanami::Repository
    prepend ImageUploader.repository(:image)
end
