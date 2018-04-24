# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
post '/code', to: 'index#sms'
post '/login', to: 'index#sign_up'
get '/project', to: 'project#index'
