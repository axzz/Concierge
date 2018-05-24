class Project < Hanami::Entity
  def min_time
    return DateTime.now unless ahead_time
    return (Date.today + ahead_time[:day].to_i).to_datetime unless ahead_time[:day].blank?
    return (Time.now + ahead_time[:hour].to_i * 3600).to_datetime unless ahead_time[:hour].blank?
    return (Time.now + ahead_time[:minute].to_i * 60).to_datetime unless ahead_time[:minute].blank?
    DateTime.now
  end

  def add_group(ids)
    group_project_repository =  GroupProjectRepository.new
    group_project_repository.clear_project(id)
    GroupRepository.new.add_total(ids)
    items = ids.map do |group_id|
      { project_id: id, group_id: group_id }
    end
    group_project_repository.create(items)
  end

  def groups
    ids = GroupProjectRepository.new.find_groups_by_project(id).to_a.map &:group_id
    GroupRepository.new.find_groups(ids).to_a
  end
end
