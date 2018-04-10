#require_relative './verify_params'

module Web::Controllers::Project
  class Create
    include Web::Action
    #include VerifyParams
    params do
      optional(:token).maybe(:str?)
      required(:name).filled(:str?)
      optional(:description).maybe(:str?)
      optional(:address).maybe(:str?)
      optional(:latitude).maybe()
      optional(:longtitude).maybe()

      required(:image).filled(:str?)

      required(:time_state).filled(:str?)
      required(:check_mode).filled(:str?)
    end

    def call(params)
      # 防止重复提交
      halt 422, ({ error: "Invalid Params in basic" }.to_json) unless params.valid?
      halt 403 unless Tools.prevent_frequent_submission(id: @user.id.to_s, method: "create_project")

      begin
        time_state = JSON.parse(params[:time_state])
        time_state_parsed = TimeTableUtils.parse_time_state(time_state)
      rescue
        halt 422, ({ error: "Invalid Params" }.to_json)
      end

      project = Project.new(
        name:               params[:name],
        description:        params[:description],
        address:            params[:address],
        latitude:           params[:latitude].to_f,
        longtitude:         params[:longtitude].to_f,
        time_state_parsed:  time_state_parsed,
        time_state:         time_state,
        state:              "open",
        check_mode:         params[:check_mode],
        creator_id:         @user.id,
        image_url:          params[:image])
      ProjectRepository.new.create(project)

      self.status = 201
      self.body = ""
    end
  end
end
