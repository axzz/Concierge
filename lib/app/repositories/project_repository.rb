class ProjectRepository < Hanami::Repository
    def get_list id,page
        # if page==1
        #    projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC LIMIT 11")
        # else
        #    projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC OFFSET #{(page*12 - 13).to_s} LIMIT 12")
        # end
        # 分页代码已写 第一期先不用

        projects.read("SELECT * FROM projects WHERE creator_id = #{id.to_s} AND state != 'delete' ORDER BY state DESC,created_at DESC")
    end

    def get_count id
        projects.where(creator_id: id).where{state.not("delete")}.count
    end
end
