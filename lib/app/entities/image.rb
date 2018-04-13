require_relative '../image_uploader'
class Image < Hanami::Entity
  include ImageUploader[:image]
  def destroy
    File.delete("./public#{image_url}")
    ImageRepository.new.delete(id)
  end
end
