module Web::Controllers::Project
  class Create
    include Web::Action

    params do
      optional(:token).maybe(:str?)
      required(:name).filled(:str?)
      optional(:description).maybe(:str?)
      optional(:address).maybe(:str?)
      optional(:latitude).maybe
      optional(:longitude).maybe
      required(:image).filled(:str?)
      required(:time_state).filled(:str?)
      required(:check_mode).filled(:str?)
      optional(:multi_time).maybe(:bool?)
      optional(:reservation_per_user).maybe(:int?)
      optional(:date_display).maybe(:int?)
      optional(:ahead_time).maybe
      optional(:group).maybe
      optional(:authority).maybe
    end

    handle_exception RuntimeError => 400,
                     ArgumentError => 422,
                     JSON::ParserError => 403

    before :validate_params

    def call(params)
      project = create_project(params)
      make_wxcode(project.id)
      TimeTableUtils.make_time_table(project.id, project.min_time.to_date)
      halt 201
    end

    private

    def validate_params(params)
      halt 422 unless params.valid?
      halt 403 unless Tools.prevent_repeat_submit(id: @user.id.to_s,
                                                  method: 'create')
    end

    def create_project(params)
      time_state = JSON.parse(params[:time_state])
      time_state_parsed = TimeTableUtils.parse_time_state(time_state)
      if params[:date_display].to_i > 10 || params[:date_display].to_i < 1
        raise ArgumentError
      end
      project = Project.new(
        name:               params[:name],
        description:        params[:description],
        address:            params[:address],
        latitude:           params[:latitude].to_f,
        longitude:          params[:longitude].to_f,
        time_state_parsed:  time_state_parsed,
        time_state:         time_state,
        state:              'open',
        check_mode:         params[:check_mode],
        creator_id:         @user.id,
        image_url:          params[:image],
        multi_time:         params[:multi_time],
        reservation_per_user: params[:reservation_per_user],
        date_display:       params[:date_display],
        authority:          params[:authority],
        ahead_time:         JSON.parse(params[:ahead_time]),
      )
      ProjectRepository.new.create(project)
    end

    def make_wxcode(project_id)
      wxcode = WxcodeUtils.make_share_project_wxcode(project_id)
      ProjectRepository.new.update(project_id, wxcode: wxcode)
    end
  end
end
