class ReservationRepository < Hanami::Repository
  NUM_PER_PAGE = 5
  
  associations do
    has_many :projects
  end

  def basic_user_reservations(user_id, page)
    reservations
      .where(creator_id: user_id)
      .limit(NUM_PER_PAGE)
      .offset((page - 1) * NUM_PER_PAGE)
  end

  def current_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where{ state.in('success','wait') }
  end

  def finished_user_reservations(user_id, page)
    basic_user_reservations(user_id, page)
      .where{ state.in('overtime','checked') }
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
    reservations
    .join(projects)
    .where{ projects[:name].ilike(data) | projects[:address].ilike(data) }
    .as(Reservation)
    # TODO: repair
  end
end
