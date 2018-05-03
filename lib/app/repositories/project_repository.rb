class ProjectRepository < Hanami::Repository
  NUM_PER_PAGE = 16
  NUM_PER_PAGE_MINI = 4

  def get_projects_for_manager(id, page)
    # if page == 1 # 15 items in first page
    #   projects.read(
    #     'SELECT * FROM projects '\
    #     "WHERE creator_id = #{id.to_i} "\
    #     "AND state IN ('open','pause')"\
    #     'ORDER BY state ,id DESC ' \
    #     "limit #{NUM_PER_PAGE - 1} "
    #   )
    # else
    #   projects.read(
    #     'SELECT * FROM projects '\
    #     "WHERE creator_id = #{id.to_i} "\
    #     "AND state IN ('open','pause')"\
    #     'ORDER BY state ,id DESC ' \
    #     "limit #{NUM_PER_PAGE} "\
    #     "OFFSET #{NUM_PER_PAGE * page - NUM_PER_PAGE - 1}"
    #   )
    # end

      projects.read(
        'SELECT * FROM projects '\
        "WHERE creator_id = #{id.to_i} "\
        "AND state IN ('open','pause')"\
        'ORDER BY state ,id DESC ' \
      )
  end

  def get_projects_for_manager_miniprogram(id, page)
    projects.read(
      'SELECT * FROM projects '\
      "WHERE creator_id = #{id.to_i} "\
      "AND state IN ('open','pause') "\
      'ORDER BY state ,id DESC '\
      "limit #{NUM_PER_PAGE_MINI} "\
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
                  "AND state IN ('open') "\
                  'ORDER BY id DESC ' \
                  "LIMIT #{NUM_PER_PAGE_MINI} " \
                  "OFFSET #{NUM_PER_PAGE_MINI * page.to_i - NUM_PER_PAGE_MINI}")
  end

  def search(data, page)
    projects
      .where { state.in('open') }
      .where { (name.ilike("%#{data}%") | address.ilike("%#{data}%")) }
      .limit(NUM_PER_PAGE_MINI)
      .offset(NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI)
  end

  associations do
    has_many :reservations
  end

  def get_projects_from_reservations(*ids)
    projects.join(reservations)
            .where(reservations[:reservation_id].in(*ids))
            .order(reservations[:reservation_id].desc)
            .as(Project)
            .to_a
  end
end
