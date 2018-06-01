require_relative '../../../spec_helper'

describe Miniprogram::Controllers::Reservation::Show do
  let(:action) { Miniprogram::Controllers::Reservation::Show.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
