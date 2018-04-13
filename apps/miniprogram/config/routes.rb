# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/projects',      to: 'project#index'
get '/projects/:id',  to: 'project#show'

get '/login',         to: 'index#login'
