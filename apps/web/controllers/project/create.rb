require 'json'

module Web::Controllers::Project
  class Create
    include Web::Action

    params do
      required(:token).filled(:str?)
      required(:name).filled(:str?)
      required(:des).filled(:str?)
      required(:address).filled(:str?)
      required(:latitude).filled(:str?)
      required(:longitude).filled(:str?)

      optional(:default_image).maybe(:str?)
      optional(:image).maybe

      required(:time_state).filled(:str?)
    # required(:check_mode).filled(:str?)
    end

    def call(params)
      unless params.valid?
        p "wrong in params"
        halt 403, ({ error: "Invalid Params" }.to_json)
      end

      name=params[:name]
      des=params[:des]

      address=params[:address]
      latitude=params[:latitude]
      longitude=params[:longitude]

      begin
        time_state=JSON.parse(params[:time_state])
        puts time_state
        time_state_parse=Tools.parse_time_state(time_state)
      rescue
        p "wrong in json"
        halt 403, ({ error: "Invalid Params" }.to_json)
      end
      
      state="open"
      check_mode=params[:check_mode]
      creator_id=@user.id

      if params[:default_image]&&params[:default_image]!=""
        default_image= params[:default_image]
        project=Project.new(name: name,des: des,address: address,latitude: latitude,longitude: longitude,time_state_parse: time_state_parse,
          time_state: time_state,state: state,check_mode: check_mode,creator_id: creator_id,default_image: default_image)
      else
        tempfile = params[:image][:tempfile]
        image= ::File.open(tempfile)
        project=Project.new(name: name,des: des,address: address,latitude: latitude,longitude: longitude,time_state_parse: time_state_parse,
          time_state: time_state,state: state,check_mode: check_mode,creator_id: creator_id,image: image)
      end
      ProjectRepository.new.create(project)

      self.status=201
      self.body={}.to_json
    end
  end
end
