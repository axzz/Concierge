class ProjectRepository < Hanami::Repository
    def get_list id,page
        if page==1
            return projects.read("SELECT * FROM projects WHERE creator_id = "+id.to_s+" AND state != 'delete' ORDER BY state DESC,created_at DESC LIMIT 11")
        else
            return projects.read("SELECT * FROM projects WHERE creator_id = "+id.to_s+" AND state != 'delete' ORDER BY state DESC,created_at DESC OFFSET "+(page*12 - 13).to_s+" LIMIT 12")
        end
    end

    def get_count id
        projects.where(creator_id: id).where{state.not("delete")}.count
    end
end
