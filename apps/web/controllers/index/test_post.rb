module Web::Controllers::Index
  class TestPost
    include Web::Action

    def call(params)
      tempfile = params[:image][:tempfile]
      image= ::File.open(tempfile)
      name=params[:name]
      des=params[:des]

      address=params[:address]
      time_table=params[:time_table]
      state=params[:state]
      check_mode=params[:check_mode]
      creator_id=UserRepository.new.find_user_by_tel(params[:tel]).id

      project=Project.new(name: name,des: des,address: address,time_table: time_table,state: state,check_mode: check_mode,
      creator_id: creator_id,image: image)

      project=ProjectRepository.new.create(project)
      puts project.image_url()
    end
  end
end
