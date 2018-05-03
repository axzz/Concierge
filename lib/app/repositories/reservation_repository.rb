class ReservationRepository < Hanami::Repository
  NUM_PER_PAGE = 4
  def find_by_project(project_id)
    reservations
      .where(project_id: project_id)
      .where { state.in('success', 'wait') }
  end

  def basic_user_reservations(user_id, page)
    reservations
      .order { reservation_id.desc }
      .where(creator_id: user_id)
      .limit(NUM_PER_PAGE_MINI)
      .offset((page - 1) * NUM_PER_PAGE_MINI)
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
    offset_num = (page - 1) * NUM_PER_PAGE_MINI
    reservations.read(
      'SELECT reservations.* ' \
      'From reservations ' \
      'INNER JOIN projects ' \
      'ON reservations.project_id = projects.id ' \
      "WHERE (projects.name ILIKE '%#{data}%' " \
      "OR projects.address ILIKE '%#{data}%') " \
      "AND reservations.creator_id = #{user_id} " \
      "ORDER BY reservation_id DESC " \
      "LIMIT #{NUM_PER_PAGE_MINI} " \
      "OFFSET #{offset_num}"
    )
  end

  NUM_PER_PAGE_MINI = 10

  def inquire(project_id, date_from, date_to, tel_num, state, page)
    tmp = reservations.where(project_id: project_id)
                      .limit(NUM_PER_PAGE_MINI)
                      .offset((page - 1) * NUM_PER_PAGE_MINI)
                      .order { reservation_id.desc }

    tmp = tmp.where { date >= Date.parse(date_from) } unless date_from.blank?
    tmp = tmp.where { date <= Date.parse(date_to) } unless date_to.blank?
    tmp = tmp.where{ tel.ilike("%#{tel_num}%") } unless tel_num.blank?
    tmp = tmp.where(state: state) unless state.blank?
    tmp
  end

  def count_inquire(project_id, date_from, date_to, tel, state)
    tmp = reservations.where(project_id: project_id)

    tmp = tmp.where { date >= Date.parse(date_from) } unless date_from.blank?
    tmp = tmp.where { date <= Date.parse(date_to) } unless date_to.blank?
    tmp = tmp.where(tel: tel) unless tel.blank?
    tmp = tmp.where(state: state) unless state.blank?
    tmp.count
  end

  def count(project_id)
    tmp = reservations.where(project_id: project_id)
    {
      total: tmp.count,
      success: tmp.where(state: 'success').count,
      wait: tmp.where(state: 'wait').count,
      overtime: tmp.where(state: 'overtime').count,
      checked: tmp.where(state: 'checked').count,
      cancelled: tmp.where(state: 'cancelled').count,
      refused: tmp.where(state: 'refused').count
    }
  end

  def refresh_reservations()
    tmp = reservations.where { state.in('success', 'wait')}
                      .where { date < Date.today }
    overtime(tmp)
    tmp = reservations.where { state.in('success', 'wait')}
                     .where(date: Date.today)
    overtime_today(tmp)
  end

  def overtime(tmp_reservations)
    repository = ReservationRepository.new
    tmp_reservations.each do |reservation|
      repository.update(reservation.reservation_id, state: 'overtime', remark: '预约过期，系统自动取消')
    end
  end

  def overtime_today(tmp_reservations)
    repository = ReservationRepository.new
    tmp_reservations.each do |reservation|
      period = TimePeriod.new(reservation.time)
      repository.update(reservation.reservation_id, state: 'overtime', remark: '预约过期，系统自动取消') if period.end < DateTime.now
    end
  end

  def cancel_all(project_id)
    reservations.where(project_id: project_id)
                .where { state.in('success','wait') }
                .each do |reservation|
                  update(reservation.reservation_id, state: 'cancelled', remark: '管理员暂停了预约项目')
                end
  end
end
