class GroupProjectRepository < Hanami::Repository
  def find_projects_by_group(group_id, page, size)
    group_projects.where(group_id: group_id)
                  .limit(size)
                  .offset(size * page - size)
  end

  def clear(group_id)
    group_projects.where(group_id: group_id).delete
  end

  def find_groups_by_project(project_id)
    group_projects.where(project_id: project_id)
  end

  def clear_project(project_id)
    group_projects.where(project_id: project_id).delete
  end
end
