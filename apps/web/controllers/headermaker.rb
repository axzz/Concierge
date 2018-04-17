module Web
  # Set default headers at every page
  module Headermaker
    def self.included(action)
      action.class_eval do
        before :make_header
      end
    end

    private

    def make_header
      headers['Access-Control-Expose-Headers'] = 'Authorization'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, HEAD, OPTIONS, PUT'
      headers['Access-Control-Allow-Origin'] = '*' # for TEST
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, X-Custom-Header, Authorization'
      headers['Access-Control-Max-Age'] = '1728000'
      self.format = :json
    end
  end
end
