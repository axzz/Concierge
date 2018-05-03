source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.2'
gem 'hanami-model', '~> 1.2'
gem 'aliyun-sms'

gem 'sidekiq'

gem 'redis'
gem 'jwt'

gem 'shrine'
gem 'hanami-shrine'

gem 'image_processing'
gem "mini_magick", ">= 4.3.5"

gem 'pg'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :test do
  gem 'minitest'
  gem 'capybara'
end

group :production do
  # gem 'puma'
end
