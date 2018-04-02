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
      Tools.prevent_frequent_submission(id: @user.id.to_s,method: "update_project")

      unless params.valid?
        p "wrong in params"
        halt 403, ({ error: "Invalid Params" }.to_json)
      end
      
      name=params[:name]
      des=params[:des]
      check_mode=params[:check_mode]
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
      
      old_project=ProjectRepository.new.find(params[:id])

      ProjectRepository.new.update(params[:id],name: name,image_data: old_project.image)
      ProjectRepository.new.update(params[:id],name: name,des: des,check_mode: check_mode,address: address,latitude: latitude,longtitude: longtitude,image: "")
      
      time_state=JSON.parse(params[:time_state])
      time_state_parsed=Tools.parse_time_state(time_state)
      if old_project.time_state_parsed!=time_state_parsed
        #TODO: 处理预约
        ProjectRepository.new.update(params[:id],time_state: time_state,time_state_parsed: time_state_parsed,image: old_project.image)
      end

      if params[:default_image]
        default_image= params[:default_image]
        default_image= default_image[1..-1] if default_image[0]=="."
        ProjectRepository.new.update(params[:id],default_image: default_image,image: old_project.image)
      elsif params[:image]
        #改变了图片
        tempfile = params[:image][:tempfile]
        image= ::File.open(tempfile)
        ProjectRepository.new.update(params[:id],image: image,default_image: "")
      end

    end
  end
end
