require_relative './find_project'

module Web::Controllers::Project
  class Update
    include Web::Action
    include FindProject

    handle_exception JSON::ParserError => 400

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
      optional(:multi_time).maybe(:bool?)
      optional(:reservation_per_user).maybe(:int?)
      optional(:date_display).maybe(:int?)
      optional(:ahead_time).maybe
    end

    before :validate_params

    def call(params)
      ProjectRepository.new.update(
        params[:id].to_i,
        name:          params[:name],
        description:   params[:description],
        check_mode:    params[:check_mode],
        address:       params[:address],
        latitude:      params[:latitude].to_f,
        longitude:     params[:longitude].to_f,
        image_url:     params[:image],
        multi_time:    params[:multi_time],
        reservation_per_user: params[:reservation_per_user],
        date_display:  params[:date_display],
        ahead_time:    JSON.parse(params[:ahead_time])
      )
      if @project.ahead_time != JSON.parse(params[:ahead_time])
        TimeTableUtils.make_time_table(@project.id, @project.min_time.to_date)
      end
      update_time_state(params)

      halt 201, ''
    end

    private

    def validate_params(params)
      halt 422 unless params.valid?
      halt 403 unless Tools.prevent_repeat_submit(id: @user.id.to_s,
                                                  method: 'update')
      halt 422 if params[:date_display] && params[:date_display].to_i > 10
    end

    def update_time_state(params)
      time_state = JSON.parse(params[:time_state])
      time_state_parsed = TimeTableUtils.parse_time_state(time_state)

      return if @project.time_state_parsed == time_state_parsed
      TimeTableUtils.change_time_state(params[:id], time_state_parsed)
      ProjectRepository.new.update(
        params[:id],
        time_state: time_state,
        time_state_parsed: time_state_parsed
      )
    end
  end
end
