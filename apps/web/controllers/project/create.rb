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
      # 防止重复提交
      halt 403 if Tools.prevent_frequent_submission(id: @user.id.to_s,method: "create_project")
      halt 422, ({ error: "Invalid Params" }.to_json) unless params.valid?

      address = params[:address]
      if address
        latitude = params[:latitude].to_f
        longtitude = params[:longtitude].to_f
      end

      begin
        time_state = JSON.parse(params[:time_state])
        time_state_parsed = Tools.parse_time_state(time_state)
      rescue
        halt 422, ({ error: "Invalid Params in Json" }.to_json)
      end
      
      state = "open"
      check_mode = params[:check_mode]
      creator_id = @user.id

      if params[:default_image]&&params[:default_image] != ""
        image_id = nil
        image_url = params[:default_image]
        image_url = image_url[1..-1] if image_url[0] == '.' # 消除有时前端传上的'.'
      elsif params[:image]!=nil
        tempfile = params[:image][:tempfile]
        imagefile = ::File.open(tempfile)

        image = Image.new(image: imagefile)
        image = ImageRepository.new.create(image)
        image_url = image.image_url
        image_id = image.id
      else
        halt 422, ({ error: "Invalid Params in image" }.to_json)
      end

      project=Project.new(
        name: params[:name],
        des: params[:des],
        address: address,
        latitude: latitude,
        longtitude: longtitude,
        time_state_parsed: time_state_parsed,
        time_state: time_state,
        state: state,
        check_mode: check_mode,
        creator_id: creator_id,
        image_id: image_id,
        image_url: image_url)
      ProjectRepository.new.create(project)

      self.status = 201
      self.body = ""
    end
  end
end
