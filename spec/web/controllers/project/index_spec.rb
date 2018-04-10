require_relative '../../../spec_helper'

describe Web::Controllers::Project::Index do
  let(:action) { Web::Controllers::Project::Index.new }
  let(:params) { Hash[] }

  it 'no permission' do
    response = action.call(params)
    response[0].must_equal 401
  end

  it 'have permission' do
    response = action.call({token: Tools.make_token(1)})
    response[0].must_equal 200
    response[1]["Authorization"].must_equal(Tools.make_token(1))
  end
end
