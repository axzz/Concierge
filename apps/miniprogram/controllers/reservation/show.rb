module Miniprogram::Controllers::Reservation
  class Show
    include Miniprogram::Action
    def call(params)
      reservation = ReservationRepository.new.find(params[:id])
      halt 404 unless reservation
      halt 401 if reservation.creator_id != @user.id

      project = ProjectRepository.new.find(reservation.project_id)

      self.body = {
        state:        reservation.state,
        project_name: project.name,
        address:      project.address   || '',
        latitude:     project.latitude  || '',
        longitude:    project.longitude || '',
        date:         reservation.date,
        time:         reservation.time,
        name:         reservation.name,
        tel:          reservation.tel
      }.to_json
    end
  end
end
