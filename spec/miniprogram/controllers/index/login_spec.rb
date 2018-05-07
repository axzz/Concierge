require_relative '../../../spec_helper'

describe Miniprogram::Controllers::Index::Login do
  let(:action) { Miniprogram::Controllers::Index::Login.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 422
  end
end
