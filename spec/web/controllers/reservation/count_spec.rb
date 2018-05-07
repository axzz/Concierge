require_relative '../../../spec_helper'

describe Web::Controllers::Reservation::Count do
  let(:action) { Web::Controllers::Reservation::Count.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 401
  end
end
