require_relative '../../../spec_helper'

describe Web::Controllers::Index::TestPost do
  let(:action) { Web::Controllers::Index::TestPost.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 401
  end
end
