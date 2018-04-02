# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

options '/*', to: 'index#option'


post '/telephone', to: 'index#sms'
post '/sms', to: 'index#token'

post '/projects', to: 'project#create'
get '/projects/:id', to: 'project#show'
get '/projects', to: 'project#index'
put '/projects/:id', to: 'project#update'
