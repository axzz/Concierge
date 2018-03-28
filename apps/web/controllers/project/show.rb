module Web::Controllers::Project
  class Show
    include Web::Action

    def call(params)
      self.body={"state":"success"}.to_json
    end
  end
end
