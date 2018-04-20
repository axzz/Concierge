class ReservationRepository < Hanami::Repository
  NUM_PER_PAGE = 4
  def find_by_project(project_id)
    reservations
      .where(project_id: project_id)
      .where { state.in('success', 'wait') }
  end

  def basic_user_reservations(user_id, page)
    reservations
      .order{ id.desc }
      .where(creator_id: user_id)
      .limit(NUM_PER_PAGE)
      .offset((page - 1) * NUM_PER_PAGE)
  end

  def current_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where{ state.in('success', 'wait') }
  end

  def finished_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where{ state.in('overtime', 'checked') }
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

  def test()
    reservations.join(projects, id: :creator_id)
  end
end
