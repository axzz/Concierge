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

end