require_relative '../image_uploader'

class ProjectRepository < Hanami::Repository
    prepend ImageUploader.repository(:image)

    def get_list id
        projects.where(creator_id: id)
    end
end
