require_relative '../../../spec_helper'

describe Web::Controllers::Project::Show do
  let(:action) { Web::Controllers::Project::Show.new }
  let(:params) { Hash[] }

  it 'no permission' do
    response = action.call(params)
    response[0].must_equal 401
  end

  it 'no permission' do
    response = action.call({token: Tools.make_jwt(1),id: "1"})
    response[0].must_equal 200
  end
end
