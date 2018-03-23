require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store")
}

Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :rack_file # for non-Rails apps

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :hanami, validations: true
  plugin :processing
  plugin :versions 
  plugin :delete_raw 

  #process(:store) do |io, context|
  #  original = io.download

    # size_800 = resize_to_limit!(original, 800, 800)
    # size_500 = resize_to_limit(size_800,  500, 500)
    # size_300 = resize_to_limit(size_500,  300, 300)

    # {original: io, large: size_800, medium: size_500, small: size_300}
  #  {original: io}
  #end
end