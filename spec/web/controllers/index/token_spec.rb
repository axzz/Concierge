require_relative '../../../spec_helper'

describe Web::Controllers::Index::Token do
  let(:sms) { Web::Controllers::Index::Sms.new }
  let(:action) { Web::Controllers::Index::Token.new }
  let(:params) { Hash[] }
  let(:true_tel) { '13408058303' }

  it 'no params' do
    response = action.call(params)
    response[0].must_equal 422
  end

  it 'get token' do
    response = sms.call({tel: true_tel})
    response = action.call({tel: true_tel, code: '123456'})
    response[0].must_equal 200
    user = UserRepository.new.find_by_tel(true_tel)
    response[1]['Authorization'].must_equal Tools.make_jwt(user.id)
  end
end
