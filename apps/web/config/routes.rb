# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/login', to: 'index#login'
get '/test', to: 'index#test'

get '/logout', to: 'index#logout'
post '/test', to: 'index#test_post'

