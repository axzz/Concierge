require_relative '../../../spec_helper'

describe Web::Controllers::Project::Open do
  let(:action) { Web::Controllers::Project::Open.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 401
  end
end
