class ProjectRepository < Hanami::Repository
  NUM_PER_PAGE_MINI = 4

  def get_projects_for_manager(id, page)
    projects.read(
      'SELECT * FROM projects '\
      "WHERE creator_id = #{id.to_i} "\
      "AND state IN ('open','pause')"\
      'ORDER BY state DESC,id DESC'
    )
  end

  def get_projects_for_manager_miniprogram(id, page)
    projects.read(
      'SELECT * FROM projects '\
      "WHERE creator_id = #{id.to_i} "\
      "AND state IN ('open','pause')"\
      'ORDER BY state DESC,id DESC'\
      "limit #{NUM_PER_PAGE_MINI}"\
      "OFFSET #{NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI}"
    )
  end

  def get_count(id)
    projects
      .where(creator_id: id)
      .where { state.not('delete') }
      .count
  end

  def get_all_projects(page)
    projects
      .where(state: 'open')
      .limit(NUM_PER_PAGE_MINI)
      .offset(NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI)
  end

  def get_projects_in_distance(distance, latitude, longitude, page)
    calculate_distance = "(6371 * acos(cos(radians(#{latitude.to_f})) * " \
                         'cos(radians(latitude)) * ' \
                         'cos(radians(longitude) - ' \
                         "radians(#{longitude.to_f})) + " \
                         "sin(radians(#{latitude.to_f})) * " \
                         'sin(radians(latitude))))'
    projects.read('SELECT * FROM projects ' \
                  "WHERE #{calculate_distance} < #{distance.to_f} " \
                  "LIMIT #{NUM_PER_PAGE_MINI} " \
                  "OFFSET #{NUM_PER_PAGE_MINI * page.to_i - NUM_PER_PAGE_MINI}")
  end

  def search(data, page)
    projects
      .where { state.not('delete') }
      .where { (name.ilike("%#{data}%") | address.ilike("%#{data}%")) }
      .limit(NUM_PER_PAGE_MINI)
      .offset(NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI)
  end

  associations do
    has_many :reservations
  end

  def test
    projects.right_join(reservations).where
  end
end
