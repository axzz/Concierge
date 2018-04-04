module Web::Controllers::Project
  class Update
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
      halt 403 if Tools.prevent_frequent_submission(id: @user.id.to_s,method: "update_project")
      halt 422, ({ error: "Invalid Params" }.to_json) unless params.valid?
      
      address = params[:address]
      if address
        latitude = params[:latitude].to_f
        longtitude = params[:longtitude].to_f
      end
      
      old_project=ProjectRepository.new.find(params[:id].to_i)

      ProjectRepository.new.update(
        params[:id],
        name: params[:name],
        des: params[:des],
        check_mode: params[:check_mode],
        address: address,
        latitude: latitude,
        longtitude: longtitude
      )
      
      begin
        time_state = JSON.parse(params[:time_state])
        time_state_parsed = Tools.parse_time_state(time_state)
      rescue
        halt 422, ({ error: "Invalid Params in Json" }.to_json)
      end
      if old_project.time_state_parsed != time_state_parsed
        # TODO (L): 处理预约
        ProjectRepository.new.update(params[:id], time_state: time_state, time_state_parsed: time_state_parsed)
      end

      if params[:default_image]
        image_url = params[:default_image]
        image_url = image_url[1..-1] if image_url[0] == "."
        ProjectRepository.new.update(params[:id],image_url: image_url)
      elsif params[:image]
        # 改变了图片
        begin
          tempfile = params[:image][:tempfile]
          image = ::File.open(tempfile)
          image = Image.new(image: image)
          image = old_project.image_id ? ImageRepository.new.update(old_project.image_id,image) : ImageRepository.new.create(image)

          # old_image=ImageRepository.new.find old_project.image_id
          # old_image.destroy if old_image
          # TODO (L): delete old image
        rescue
          halt 422, ({ error: "Invalid Params in Image" }.to_json)
        end
        ProjectRepository.new.update(params[:id],image_id: image.id,image_url: image.image_url)
      end

      self.body=""
    end
  end
end
