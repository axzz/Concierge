require_relative '../../../spec_helper'

describe MiniprogramAdmin::Controllers::Index::Login do
  let(:action) { MiniprogramAdmin::Controllers::Index::Login.new }
  let(:params) { Hash[] }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 200
  end
end
