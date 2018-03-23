#import '../lib/test1'

module Web::Controllers::Index
  class Test
    include Web::Action

    def call(params)
      #self.format=:json
      #self.body='{"state":"success","reason":""}'
    end
  end
end
