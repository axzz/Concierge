# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

options '/*',            to: 'index#option'


post    '/code',         to: 'index#sms'
post    '/login',        to: 'index#token'

post    '/projects',     to: 'project#create'
get     '/projects/:id', to: 'project#show'
get     '/projects',     to: 'project#index'
put     '/projects/:id', to: 'project#update'

get     '/covers',       to: 'index#covers'

post    '/image',        to: 'index#upload_image'

get '/project/:id/pause', to: 'project#pause'
get '/project/:id/open', to: 'project#open'

get '/projects/:id/reservations', to: 'reservation#index'
post '/projects/:project_id/reservations/:reservation_id/cancel', to: 'reservation#cancel'
post '/projects/:project_id/reservations/:reservation_id/refuse', to: 'reservation#refuse'
post '/projects/:project_id/reservations/:reservation_id/check', to: 'reservation#check'
post '/projects/:project_id/reservations/:reservation_id/pass', to: 'reservation#pass'

get '/projects/:project_id/reservations/count', to: 'reservation#count'
