# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get  '/projects',         to: 'project#index'
get  '/projects/:id',     to: 'project#show'
post '/projects/:id/code', to: 'index#sms'

post '/login',            to: 'index#login'

get  '/reservations',      to: 'reservation#index'
post '/reservations',      to: 'reservation#create'

post '/reservations/:id/cancel', to: 'reservation#cancel'
get '/groups/:id', to: 'group#show'

get '/reservations/:id', to: 'reservation#show'
