module Web::Controllers::Project
  class Index
    include Web::Action

    def call(params)
      self.body={"state":"success"}.to_json
    end
  end
end
