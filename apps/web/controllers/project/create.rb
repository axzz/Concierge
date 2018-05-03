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
    end

    handle_exception RuntimeError => 400, 
                     ArgumentError => 422

    before :validate_params

    def call(params)
      project = create_project(params)
      TimeTableUtils.make_time_table(project.id)
      halt 201, ''
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
        image_url:          params[:image]
      )
      ProjectRepository.new.create(project)
    end

  end
end
