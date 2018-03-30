# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

options '/*', to: 'index#test'

get '/login', to: 'index#login'
get '/test', to: 'index#test'

post '/test', to: 'index#test_post'

post '/projects', to: 'project#create'
get '/projects/:id', to: 'project#show'
get '/projects', to: 'project#index'
put '/projects/:id', to: 'project#update'
get '/index', to: 'index#option'
