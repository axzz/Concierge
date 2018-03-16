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
    response[2][0].must_equal ({state: 'success',reason: ''}.to_json)
  end

  it 'fail to get SMS' do
    response = action.call(tel: '1234')
    response[0].must_equal 200
    response[2][0].must_equal ({state: 'fail',reason: '手机号不符规范'}.to_json)
  end

  it 'success to get token' do
    action.call(tel: '17713441928')
    response = action.call(tel: tel,code: '123456')
    response[0].must_equal 200
    JSON.parse(response[2][0])["state"].must_equal "success"
  end

  it 'fail to get token' do
    action.call(tel: '17713441928')
    response = action.call(tel: tel,code: '123457')
    response[0].must_equal 200
    JSON.parse(response[2][0])["state"].must_equal "fail"
  end


<<<<<<< HEAD
  it 'success to login' do
    action.call(tel: '17713441928')
    response = action.call(tel: tel,code: '123456')
    token=JSON.parse(response[2][0])["token"]
    response=if_login.call(tel: tel,token: token)
    (JSON.parse(response[2][0])["state"]).must_equal "success"
=======
  it 'success to log out' do
    action.call(tel: '17713441928')
    response = action.call(tel: tel,code: '123456')
    token=response[2][0])["token"]

>>>>>>> 425fe4d0962308ebaadcb19f04cf6e019338d427
  end

  it 'success to logout' do
    action.call(tel: '17713441928')
    response = action.call(tel: tel,code: '123456')
    token=JSON.parse(response[2][0])["token"]
    out.call(tel: tel,token: token)
    response=if_login.call(tel: tel,token: token)
    (JSON.parse(response[2][0])["state"]).must_equal "success"
  end

  #TODO: 不能测试中间件执行效果
end
