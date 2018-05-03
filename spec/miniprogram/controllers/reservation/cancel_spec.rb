require_relative '../../../spec_helper'

describe Miniprogram::Controllers::Reservation::Cancel do
  let(:action) { Miniprogram::Controllers::Reservation::Cancel.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
