require_relative '../../../spec_helper'

describe Miniprogram::Controllers::Reservation::Create do
  let(:action) { Miniprogram::Controllers::Reservation::Create.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
