module Miniprogram::Controllers::Reservation
  class Create
    include Miniprogram::Action

    params do
      required(:project_id).filled
      optional(:token).maybe
      optional(:code).maybe
      required(:name).filled(:str?)
      required(:tel).filled(:str?)
      required(:date).filled(:str?)
      required(:time).filled
    end

    before :validate_params

    def call(params)
      halt 422 unless verify_sms(params)
      halt 403 if @user.achieve_limit?(params[:project_id])
      state = @project.check_mode == 'auto' ? 'success' : 'wait'
      date = Date.parse(params[:date])
      time = params[:time]
      reservation = make_reservation(params, state, date, time)

      # Database handle
      halt 403 unless TimeTableRepository.new(params[:project_id])
                                         .reduce_remain(date, time)
      reservation = ReservationRepository.new.create(reservation)
      UserRepository.new.update(@user.id,
                                tmp_tel: params[:tel],
                                tmp_name: params[:name])
      no_need_sms
      halt 201, { id: reservation.reservation_id }.to_json
    end

    private


    def validate_params(params)
      halt 422 unless params.valid?
      halt 403 unless Tools.prevent_repeat_submit(id: @user.id.to_s,
                                                  method: 'create_reservation')
      @project = ProjectRepository.new.find(params[:project_id])
      halt 404 unless @project
      halt 403, 'Project is closed' unless @project.state == 'open'

      begin
        times = params[:time]
        times.each { |time| TimePeriod.new(time) }
      rescue ArgumentError
        halt 422, 'Unsupport time format'
      end
    end
    
    def verify_sms(params)
      tel = Redis.new.get("need_sms.#{@user.id}")
      if tel && tel == params[:tel]
        true # No need sms in one hour
      else
        return false unless params[:code]
        SmsService.new(params[:tel], "reservation_#{params[:project_id]}")
                  .verify_sms(params[:code])
      end
    end

    def no_need_sms
      Redis.new.set("need_sms.#{@user.id}", params[:tel].to_s, ex: 3600)
    end

    def make_reservation(params, state, date, time)
      Reservation.new(
        creator_id: @user.id,
        project_id: params[:project_id],
        tel:        params[:tel],
        name:       params[:name],
        date:       date,
        time:       time,
        state:      state
      )
    end
  end
end
