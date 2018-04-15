module Web::Controllers::Project
  class Update
    include Web::Action
    params do
      optional(:token).maybe(:str?)
      optional(:id).maybe(:str?)
      required(:name).filled(:str?)
      optional(:description).maybe(:str?)
      optional(:address).maybe(:str?)
      optional(:latitude).maybe()
      optional(:longitude).maybe()
      required(:image).filled(:str?)
      required(:time_state).filled(:str?)
      required(:check_mode).filled(:str?)
    end

    def call(params)
      halt 422, { error: 'Invalid Params' }.to_json unless params.valid?
      halt 403 unless Tools.prevent_frequent_submission(id: @user.id.to_s,
                                                        method: 'update')
      halt 401 unless @old_project.creator_id == @user.id

      ProjectRepository.new.update(
        params[:id].to_i,
        name:          params[:name],
        description:   params[:description],
        check_mode:    params[:check_mode],
        address:       params[:address],
        latitude:      params[:latitude].to_f,
        longitude:    params[:longitude].to_f,
        image_url:     params[:image]
      )

      begin
        update_time_state(params)
      rescue StandardError
        halt 422, ({ error: 'Invalid Params in Json' }.to_json)
      end

      self.status = 201
      self.body = ''
    end

    def update_time_state(params)
      time_state = JSON.parse(params[:time_state])
      time_state_parsed = TimeTableUtils.parse_time_state(time_state)
      return if @old_project.time_state_parsed == time_state_parsed
      # TODO: handle reservations
      TimeTableUtils.change_time_state(params[:id], time_state_parsed)
      ProjectRepository.new.update(
        params[:id],
        time_state: time_state,
        time_state_parsed: time_state_parsed
      )
    end
  end
end
