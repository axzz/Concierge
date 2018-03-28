require_relative '../../../spec_helper'
require 'json'

describe Web::Controllers::Index::Login do
  let(:action) { Web::Controllers::Index::Login.new }
  let(:if_login) { Web::Controllers::Index::Test.new}
  let(:out) {Web::Controllers::Index::Logout.new}
  let(:tel) {'17713441928'}

  it 'success to get SMS' do
    response = action.call(tel: tel)
    response[0].must_equal 200
    response[2][0].must_equal ("")
  end

  it 'fail to get SMS' do
    response = action.call(tel: '1234')
    response[0].must_equal 403
    response[2][0].must_equal ({error: '手机号不符规范'}.to_json)
  end

  it 'success to get token' do
    action.call(tel: '13400000000')
    response = action.call(tel: tel,code: '123456')
    response[0].must_equal 200
  end

  it 'fail to get token' do
    action.call(tel: '13400000000')
    response = action.call(tel: tel,code: '123457')
    response[0].must_equal 403
  end

  it 'success to login' do
    action.call(tel: '13400000000')
    response = action.call(tel: tel,code: '123456')
    token=response[1]["Authorization"]
    response=if_login.call({"Authorization" => token})
    response[0].must_equal 200
  end

end
