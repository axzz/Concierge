require_relative '../../../spec_helper'
require 'json'

describe Web::Controllers::Index::Login do
  let(:action) { Web::Controllers::Index::Login.new }
  let(:params) { Hash[] }

  it 'success to get SMS' do
    response = action.call(tel: '17713441928')
    response[0].must_equal 200
    response[2][0].must_equal ({state: 'success',reason: ''}.to_json)
  end

  it 'fail to get SMS' do
    response = action.call(tel: '1234')
    response[0].must_equal 200
    response[2][0].must_equal ({state: 'fail',reason: '手机号不符规范'}.to_json)
  end

  it 'success to get token' do
    action.call(tel: '17713441928')
    response = action.call(tel: '17713441928',code: '123456')
    response[0].must_equal 200
    JSON.parse(response[2][0])["state"].must_equal "success"
  end

  it 'fail to get token' do
    action.call(tel: '17713441928')
    response = action.call(tel: '17713441928',code: '123457')
    response[0].must_equal 200
    JSON.parse(response[2][0])["state"].must_equal "fail"
  end

  it 'fail to get token' do
    action.call(tel: '17713441928')
    response = action.call(tel: '17713441929',code: '123457')
    response[0].must_equal 200
    JSON.parse(response[2][0])["state"].must_equal "fail"
  end
end
