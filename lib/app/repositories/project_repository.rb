class ProjectRepository < Hanami::Repository
  NUM_PER_PAGE = 16
  NUM_PER_PAGE_MINI = 4

  def get_projects_for_manager(id, page, size)
    projects.read(
      'SELECT * FROM projects '\
      "WHERE creator_id = #{id.to_i} "\
      "AND state IN ('open','pause')"\
      'ORDER BY state ,id DESC ' \
      "limit #{size} "\
      "OFFSET #{size * page - size}"
    )
  end

  def search_projects_for_manager(id, page, size, search)
    projects.read(
      'SELECT * FROM projects '\
      "WHERE creator_id = #{id.to_i} "\
      "AND NAME ILIKE '%#{search}%' OR ADDRESS ILIKE '%#{search}%'"\
      "AND state IN ('open','pause')"\
      'ORDER BY state ,id DESC ' \
      "limit #{size} "\
      "OFFSET #{size * page - size}"
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
      .where(state: 'open', authority: 'public')
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
                  "AND state = 'open' "\
                  "AND authority = 'public' "\
                  'ORDER BY id DESC ' \
                  "LIMIT #{NUM_PER_PAGE_MINI} " \
                  "OFFSET #{NUM_PER_PAGE_MINI * page.to_i - NUM_PER_PAGE_MINI}")
  end

  def search(data, page)
    projects
      .where(state:'open', authority: 'public')
      .where { (name.ilike("%#{data}%") | address.ilike("%#{data}%")) }
      .limit(NUM_PER_PAGE_MINI)
      .offset(NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI)
  end

  associations do
    has_many :reservations
  end

  def get_projects_from_reservations(ids)
    projects.join(reservations)
            .where(reservations[:reservation_id].in(*ids))
            .order(reservations[:reservation_id].desc)
            .as(Project)
            .to_a
  end

  def everyday_send_to_manager
    need_send = projects.read('SELECT projects.creator_id, projects.id, projects.name FROM projects '\
      'INNER JOIN reservations ON projects.id = reservations.project_id '\
      'WHERE reservations.date =  current_date '\
      "AND reservations.state = 'success'").to_a
    results = []
    need_send.each do |project|
      flag = false
      results.each do |result|
        next unless result[:project].id == project.id
        result[:num] += 1
        flag = true
        break
      end
      results << { project: project, num: 1 } unless flag
    end

    user_repository = UserRepository.new
    results.each do |result|
      user = user_repository.find(result[:project].creator_id)
      SmsService
        .new(user.tel)
        .send_manager_everyday_notice_sms(result[:project], result[:num])
    end
  end

  def find_projects(ids)
    projects.where { id.in(*ids) }.order{ id.desc }
  end
end
