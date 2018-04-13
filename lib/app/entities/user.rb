class User < Hanami::Entity
  def projects(page: 1)
    ProjectRepository.new.get_projects_for_manager(self.id, page)
  end

  def projects_num
    ProjectRepository.new.get_count(id)
  end
end
