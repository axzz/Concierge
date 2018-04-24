module Miniprogram::Controllers::Reservation
  class Create
    include Miniprogram::Action

    params do
      required(:project_id).filled
      required(:code).filled(:str?)
      required(:name).filled(:str?)
      required(:tel).filled(:str?)
      required(:date).filled(:str?)
      required(:time).filled(:str?)
    end

    def call(params)
      halt 422 unless params.valid?
      halt 403 unless Tools.prevent_repeat_submit(id: @user.id.to_s,
                                                  method: 'create_reservation')
      halt 422 unless verify_sms(params)

      project = ProjectRepository.new.find(params[:project_id])
      halt 404 unless project
      halt 403 unless project.state == 'open'

      state = project.check_mode == 'auto' ? 'success' : 'wait'
      date = Date.parse(params[:date])

      reservation = make_reservation(params, state, date)

      halt 422 if TimePeriod.new(params[:time]).error
      # Database handle
      TimeTableRepository.new(params[:project_id])
                         .reduce_remain(date, params[:time])
      reservation = ReservationRepository.new.create(reservation)
      UserRepository.new.update(@user.id,
                                tmp_tel: params[:tel],
                                tmp_name: params[:name])
      halt 201, { id: reservation.id }.to_json
    end

    private

    def verify_sms(params)
      SmsService.new(params[:tel], "reservation_#{params[:project_id]}")
                .verify_sms(params[:code])
    end

    def make_reservation(params, state, date)
      Reservation.new(
        creator_id: @user.id,
        project_id: params[:project_id],
        tel:        params[:tel],
        name:       params[:name],
        date:       date,
        time:       params[:time],
        state:      state
      )
    end
  end
end
