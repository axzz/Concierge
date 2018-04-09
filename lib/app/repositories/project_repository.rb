class ProjectRepository < Hanami::Repository
  def get_list(id, page)
    # if page==1
    #  projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC LIMIT 11")
    # else 
    #  projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC OFFSET #{(page*12 - 13).to_s} LIMIT 12")
    # end
    #p projects.where(creator_id: id.to_s).where{ state.not('delete') }.order{ state.desc  created_at.desc }.offset(11)
    projects.read "SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC"
    
    # TODO (L): 无法多次order
  end

  def get_count(id)
    projects.where(creator_id: id).where { state.not("delete") }.count
  end
end
