require_relative '../../../spec_helper'

describe Web::Controllers::Project::Create do
  let(:action) { Web::Controllers::Project::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 401
  end
end
