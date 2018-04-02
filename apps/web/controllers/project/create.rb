require 'json'

module Web::Controllers::Project
  class Create
    include Web::Action

    params do
      optional(:token).maybe(:str?)
      required(:name).filled(:str?)
      required(:des).maybe(:str?)
      required(:address).maybe(:str?)
      required(:latitude).maybe()
      required(:longtitude).maybe()

      optional(:default_image).maybe(:str?)
      optional(:image).maybe()

      required(:time_state).filled(:str?)
      required(:check_mode).filled(:str?)
    end

    def call(params)
      #防止重复提交
      Tools.prevent_frequent_submission(id: @user.id.to_s,method: "create_project")

      unless params.valid?
        p "wrong in params"
        halt 403, ({ error: "Invalid Params" }.to_json)
      end

      name=params[:name]
      des=params[:des]

      address=params[:address]

      if address
        begin
          latitude=params[:latitude].to_f
          longtitude=params[:longtitude].to_f
        rescue
          p "wrong in address"
          halt 403, ({ error: "Invalid Params" }.to_json)
        end
      end

      begin
        time_state=JSON.parse(params[:time_state])
        time_state_parsed=Tools.parse_time_state(time_state)
      rescue
        p "wrong in json"
        halt 403, ({ error: "Invalid Params" }.to_json)
      end
      
      state="open"
      check_mode=params[:check_mode]
      creator_id=@user.id

      if params[:default_image]&&params[:default_image]!=""
        image_url= params[:default_image]
        image_url= image_url[1..-1] if image_url[0]=="."
        project=Project.new(name: name,des: des,address: address,latitude: latitude,longtitude: longtitude,time_state_parsed: time_state_parsed,
          time_state: time_state,state: state,check_mode: check_mode,creator_id: creator_id,image_url: image_url)
      elsif params[:image]!=nil
        tempfile = params[:image][:tempfile]
        image= ::File.open(tempfile)
        image=Image.new(image: image)
        image=ImageRepository.new.create(image)
        
        project=Project.new(name: name,des: des,address: address,latitude: latitude,longtitude: longtitude,time_state_parsed: time_state_parsed,
          time_state: time_state,state: state,check_mode: check_mode,creator_id: creator_id,image_id: image.id,image_url: image.image_url)
      else
        p "wrong in image"
        halt 403, ({ error: "Invalid Params" }.to_json)
      end

      ProjectRepository.new.create(project)

      self.status=201
      self.body={}.to_json
    end
  end
end
