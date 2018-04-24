require_relative '../../../spec_helper'

describe Web::Controllers::Reservation::Check do
  let(:action) { Web::Controllers::Reservation::Check.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
