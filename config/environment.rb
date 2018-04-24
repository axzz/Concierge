require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/app'
require_relative '../apps/miniprogram_admin/application'
require_relative '../apps/miniprogram/application'
require_relative '../apps/web/application'

Hanami.configure do
  mount MiniprogramAdmin::Application, at: '/miniprogram/admin'
  mount Miniprogram::Application, at: '/miniprogram'
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/app_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/app_development'
    #    adapter :sql, 'mysql://localhost/app_development'
    #
    adapter :sql, ENV['DATABASE_URL']

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/app/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :info, stream: 'log/development.log'
  end

  environment :production do
    logger level: :info, formatter: :json, filter: [], stream: 'log/production.log'
    

    mailer do
      delivery :smtp, address: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    end
  end
end
