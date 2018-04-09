#require_relative './verify_params'

module Web::Controllers::Project
  class Update
    include Web::Action
    #include VerifyParams
    params do
      optional(:token).maybe(:str?)
      required(:name).filled(:str?)
      required(:description).maybe(:str?)
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
      halt 403 if Tools.prevent_frequent_submission(id: @user.id.to_s,method: "update_project")
      halt 422, ({ error: "Invalid Params" }.to_json) unless params.valid?

      update_basic(params)
      
      update_time_state(params)

      update_image(params)

      self.body=""
    end

    def update_basic(params)
      ProjectRepository.new.update(
        params[:id],
        name: params[:name],
        description: params[:description],
        check_mode: params[:check_mode],
        address: params[:address],
        latitude: params[:latitude].to_f,
        longtitude: params[:longtitude].to_f
      )
    end

    def update_time_state(params)
      begin
        old_project = ProjectRepository.new.find(params[:id].to_i)
        time_state = JSON.parse(params[:time_state])
        time_state_parsed = TimeTableUtils.parse_time_state(time_state)
        if old_project.time_state_parsed != time_state_parsed
          # TODO (L): 处理预约
          ProjectRepository.new.update(params[:id], time_state: time_state, time_state_parsed: time_state_parsed)
        end
      rescue
        halt 422, ({ error: "Invalid Params in Json" }.to_json)
      end
    end

    def update_image(params)
      if params[:default_image]
        image_url = params[:default_image]
        image_url = image_url[1..-1] if image_url[0] == "."
        ProjectRepository.new.update(params[:id],image_url: image_url)
      elsif params[:image]
        # 改变了图片
        begin
          old_project = ProjectRepository.new.find(params[:id].to_i)
          image = ::File.open(params[:image][:tempfile])
          image = Image.new(image: image)
          image = ImageRepository.new.create(image)
          if old_project.image_id
            old_image = ImageRepository.new.find(old_project.image_id)
            old_image.destroy
          end
          ProjectRepository.new.update(params[:id], image_id: image.id, image_url: image.image_url)
        rescue
          halt 422, ({ error: "Invalid Params in Image" }.to_json)
        end
      end
    end
  end
end
