require_relative '../../../spec_helper'

describe MiniprogramAdmin::Controllers::Project::Index do
  let(:action) { MiniprogramAdmin::Controllers::Project::Index.new }
  let(:params) { Hash[] }

  it 'no token' do
    response = action.call(params)
    response[0].must_equal 401
  end
end
