class Group < Hanami::Entity
  def projects(page = 1, size = 10_000)
    relation = GroupProjectRepository
               .new
               .find_projects_by_group(id, page, size)
               .to_a
    ids = relation.map &:project_id
    ProjectRepository.new.find_projects(ids)
  end

  def clear
    GroupProjectRepository.new.clear(id)
    GroupRepository.new.clear_total(id)
  end

  def add_projects(projects)
    GroupRepository.new.set_total(id, projects.length)
    items = projects.map { |project_id| { group_id: id, project_id: project_id } }
    GroupProjectRepository.new.create(items)
  end
end
