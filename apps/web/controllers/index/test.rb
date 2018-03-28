#import '../lib/test1'

module Web::Controllers::Index
  class Test
    include Web::Action

    def call(params)
      #puts @user.name
      #self.body={"state":"success"}.to_json
      self.format="html"
    end
  end
end
