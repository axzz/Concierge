require 'json'

module Web::Controllers::Project
  class Create
    include Web::Action

    def call(params)

      name=params[:name]
      des=params[:des]

      if params[:default_image]
        image= ::File.open(params[:default_image])
        #还用不了
      else
        tempfile = params[:image][:tempfile]
        image= ::File.open(tempfile)
      end
      
      address=params[:address]
      latitude=params[:latitude]
      longitude=params[:longitude]

      time_state=JSON.parse(params[:time_state])
      time_state_parse=TimeTable.parse_time_state()
      state="open"
      check_mode=params[:check_mode]
      creator_id=@user.id

      project=Project.new(name: name,des: des,address: address,latitude: latitude,longitude: longitude,
        time_state: time_state,state: state,check_mode: check_mode,creator_id: creator_id,image: image)

      self.status=201
      self.body={"state":"success"}.to_json
    end
  end
end
