require_relative '../../../spec_helper'

describe Web::Controllers::Index::Sms do
  let(:action) { Web::Controllers::Index::Sms.new }
  let(:params) { Hash[] }

  it 'no params' do
    response = action.call(params)
    response[0].must_equal 403
  end

  it 'bad tel' do
    response = action.call({tel: '11408058303'})
    response[0].must_equal 403
  end

  it 'right tel' do
    response = action.call({tel: '13408058303'})
    response[0].must_equal 200
  end

end
