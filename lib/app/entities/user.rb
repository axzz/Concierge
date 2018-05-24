class User < Hanami::Entity
  def projects(page: 1, size: 12)
    ProjectRepository.new.get_projects_for_manager(id, page, size)
  end

  def projects_miniprogram(page: 1)
    ProjectRepository.new.get_projects_for_manager_miniprogram(id, page)
  end

  def projects_num
    ProjectRepository.new.get_count(id)
  end

  def manager?
    tel
  end

  def role
    tel ? 'manager' : 'customer'
  end

  def achieve_limit?(project_id)
    ReservationRepository.new.user_achieve_limit?(id, project_id)
  end
end
