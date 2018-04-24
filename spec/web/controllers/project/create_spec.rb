require_relative '../../../spec_helper'

describe Web::Controllers::Project::Create do
  let(:action) { Web::Controllers::Project::Create.new }
  let(:params) { Hash[] }
  # let(:time_state) { {
  #   "normal":[
  #       {"time": "09:00-10:00", "limit": 10, "weekday": ["Sat","Sun"]},
  #       {"time": "11:00-12:00", "limit": 10, "weekday": ["Mon","Tues","Wed","Thur","Fri"]},
  #       {"time": "14:00-16:00", "limit": 10, "weekday": ["Holiday"]}
  #   ],
  #   "special":[
  #       {"Date": "2018-04-03","state": "open" , "time_table":[{"time": "9:00-10:30","limit": 100},{"time":"11:30-13:00","limit": 200}]},
  #       {"Date": "2018-05-01","state": "close" }
  #   ]
  # }.to_json }
  it 'no permission' do
    response = action.call({})
    response[0].must_equal 401
  end

  it 'create table without image and json' do
    response = action.call(token: Tools.make_jwt(1), name: 'test')
    response[0].must_equal 422
  end

  it 'create table' do
    sleep 1
    param = { token: Tools.make_jwt(1),
              name: 'test',
              time_state: time_state,
              image: '/test/test.jpg',
              check_mode: 'auto' }
    response = action.call(param)
    response[0].must_equal 201
  end
end
