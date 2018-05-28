class GroupRepository < Hanami::Repository
  def get_groups(user_id)
    groups.where(creator_id: user_id)
  end

  def find_groups(ids)
    groups.where { id.in(*ids) }
  end

  def clear_total(group_id)
    set_total(group_id, 0)
  end

  def set_total(group_id, num)
    groups.where(id: group_id).update(total: num)
  end

  def add_total(ids)
    str = ids.shift.to_s
    ids.each { |id| str << (',' + id.to_s) }
    groups.read(
      "UPDATE groups SET total = total + 1 WHERE id IN (#{str})"
    ).to_a
  end
end
