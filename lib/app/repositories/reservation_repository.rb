class ReservationRepository < Hanami::Repository
  NUM_PER_PAGE = 4
  def find_by_project(project_id)
    reservations
      .where(project_id: project_id)
      .where { state.in('success', 'wait') }
  end

  def basic_user_reservations(user_id, page)
    # TODO: 把过期的状态改为过期
    reservations
      .order { id.desc }
      .where(creator_id: user_id)
      .limit(NUM_PER_PAGE)
      .offset((page - 1) * NUM_PER_PAGE)
  end

  def current_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where { state.in('success', 'wait') }
  end

  def finished_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where { state.in('overtime', 'checked') }
  end

  def cancelled_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where(state: 'cancelled')
  end

  def refused_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where(state: 'refused')
  end

  def search(data, user_id, page)
    offset_num = (page - 1) * NUM_PER_PAGE
    reservations.read(
      'SELECT reservations.* ' \
      'From reservations ' \
      'INNER JOIN projects ' \
      'ON reservations.project_id = projects.id ' \
      "WHERE (projects.name ILIKE '%#{data}%' " \
      "OR projects.address ILIKE '%#{data}%') " \
      "AND reservations.creator_id = #{user_id} " \
      "ORDER BY id DESC " \
      "LIMIT #{NUM_PER_PAGE} " \
      "OFFSET #{offset_num}"
    )
  end

  NUM_PER_PAGE_PC = 10

  def inquire(project_id, date_from, date_to, tel, state, page)
    tmp = reservations.where(project_id: project_id)
                      .limit(NUM_PER_PAGE_PC)
                      .offset((page - 1) * NUM_PER_PAGE_PC)
                      .order { id.desc }


    tmp = tmp.where { date >= Date.parse(date_from) } unless date_from.blank?
    tmp = tmp.where { date <= Date.parse(date_to) } unless date_to.blank?
    tmp = tmp.where(tel: tel) unless tel.blank?
    tmp = tmp.where(state: state) unless state.blank?
    tmp
  end

  def refresh_reservations()
    tmp = reservations.where(state: 'success')
                      .where{ date <= date.today }
    overtime(tmp)
    tmp = reservation.where(state: 'success')
                     .where(date: date.today)
    overtime_today(tmp)
  end

  def overtime(tmp_reservations)
    repository = ReservationRepository.new
    tmp_reservations.each do |reservation|
      repository.update(reservation.id, state: 'overtime')
    end
  end

  def overtime_today(tmp_reservations)
    repository = ReservationRepository.new
    tmp_reservations.each do |reservation|
      period = TimePeriod.new(reservation.time)
      repository.update(reservation.id, state: 'overtime') if period.end_time > DateTime.now
    end
  end

  def cancel_all(project_id)
    reservations.where(project_id: project_id)
                .where { state.in('success','wait') }
                .each do |reservation|
                  update(reservation.id, state: 'cancelled')
                end
  end

  # def test
  #   reservations
  # end
end

# class ROM::Relation::Composite
#   def transform_to_miniprogram_reservation
#     response = []
#     project_repository = ProjectRepository.new
#     reservations.each do |reservation|
#       project = project_repository.find(reservation.project_id)
#       response << {
#         id:           reservation.id,
#         state:        reservation.state,
#         project_name: project.name,
#         address:      project.address || '',
#         latitude:     project.latitude || '',
#         longitude:    project.longitude || '',
#         share_code:   '',
#         date:         reservation.date,
#         time:         reservation.time,
#         name:         reservation.name,
#         tel:          reservation.tel
#       }
#     end
#     response
#   end
# end