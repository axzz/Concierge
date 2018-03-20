module Web::Controllers::Index
  class TestPost
    include Web::Action
    expose :fname,:lname

    def call(params)
      @fname=params[:fname]
      @lname=params[:lname]
      @pic=params[:pic]
    end
  end
end
