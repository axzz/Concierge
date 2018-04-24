require_relative '../../../spec_helper'

describe Web::Controllers::Index::UploadImage do
  let(:action) { Web::Controllers::Index::UploadImage.new }
  let(:params) { Hash[] }

  it 'no token' do
    response = action.call(params)
    response[0].must_equal 401
  end

  it 'no image' do
    response = action.call({ token: Tools.make_jwt(1) })
    response[0].must_equal 422
  end
end
