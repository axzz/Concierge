module Miniprogram::Views::Reservation
  class Show
    include Miniprogram::View
    format :json

    def render
      raw ({
        id:           reservation.reservation_id,
        state:        reservation.state,
        project_id:   project.id,
        project_name: project.name,
        project_state: project.state,
        address:      project.address || '',
        latitude:     project.latitude || '',
        longitude:    project.longitude || '',
        share_code:   '',
        date:         reservation.date,
        time:         reservation.time,
        name:         reservation.name,
        tel:          reservation.tel,
        update_time:  reservation.updated_at,
        remark:       reservation.remark
      }.to_json)
    end
  end
end
