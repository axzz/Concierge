#require_relative './verify_params'

module Web::Controllers::Project
  class Create
    include Web::Action
    #include VerifyParams
    params do
      optional(:token).filled(:str?)
      required(:name).filled(:str?)
      optional(:description).filled(:str?)
      optional(:address).filled(:str?)
      optional(:latitude).filled()
      optional(:longtitude).filled()

      optional(:default_image).filled(:str?)
      optional(:image).filled()

      required(:time_state).filled(:str?)
      required(:check_mode).filled(:str?)
    end

    def call(params)
      # 防止重复提交
      halt 403 if Tools.prevent_frequent_submission(id: @user.id.to_s, method: "create_project")
      halt 422, ({ error: "Invalid Params" }.to_json) unless params.valid?
      
      begin
        time_state = JSON.parse(params[:time_state])
        time_state_parsed = TimeTableUtils.parse_time_state(time_state)
        image_url, image_id = get_image(params)
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
        image_id:           image_id,
        image_url:          image_url)
      ProjectRepository.new.create(project)

      self.status = 201
      self.body = ""
    end

    def get_image(params)
      if params[:default_image]&&params[:default_image] != "" #用户使用默认图片
        image_url = params[:default_image]
        image_url[0] = '' if image_url[0] == '.' # 消除有时前端传上的'.'
        image_url
      elsif params[:image]!=nil #用户自定义图片
        imagefile = ::File.open(params[:image][:tempfile])
        image = Image.new(image: imagefile)
        image = ImageRepository.new.create(image)

        image_url = image.image_url
        image_id = image.id
        return image_url, image_id
      else
        "/static/images/img0" #默认图片
      end
    end
  end
end
