class ProjectRepository < Hanami::Repository
  NUM_PER_PAGE_MINI = 3

  def get_projects_for_manager(id, page)
    # if page==1
    #  projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC LIMIT 11")
    # else 
    #  projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC OFFSET #{(page*12 - 13).to_s} LIMIT 12")
    # end
    projects.where(creator_id: id).where{ state.not('delete') }.order{ created_at.desc }
  end

  def get_count(id)
    projects.where(creator_id: id).where { state.not("delete") }.count
  end

  def get_all_projects(page)
    projects.where(state: 'open').limit(NUM_PER_PAGE_MINI).offset(NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI)
  end

  def get_all_count
    projects.where(state: 'open').count
  end

  def get_projects_in_distance(distance, latitude, longitude, page)
    projects.read("SELECT * FROM projects WHERE #{calculate_distance(latitude, longitude)} < #{distance.to_f} LIMIT #{NUM_PER_PAGE_MINI} OFFSET #{NUM_PER_PAGE_MINI * page.to_i - NUM_PER_PAGE_MINI}")
  end

  def get_count_in_distance(distance, latitude, longitude)
    projects.read("SELECT * FROM projects WHERE #{calculate_distance(latitude, longitude)} < #{distance.to_f}").count
  end

  def search_count data
    projects
    .where { state.not('delete') }
    .where { (name.ilike("%#{data}%") | address.ilike("%#{data}%")) }
    .count
  end

  def search(data, page)
    projects
    .where { state.not('delete') }
    .where { (name.ilike("%#{data}%") | address.ilike("%#{data}%")) }
    .limit(NUM_PER_PAGE_MINI)
    .offset(NUM_PER_PAGE_MINI * page - NUM_PER_PAGE_MINI)
  end

  def calculate_distance(latitude, longitude)
    "(6371 * acos(cos(radians(#{latitude.to_f})) * " \
    "cos(radians(latitude)) * " \
    "cos(radians(longitude) - " \
    "radians(#{longitude.to_f})) + " \
    "sin(radians(#{latitude.to_f})) * " \
    "sin(radians(latitude))))"
  end
end
