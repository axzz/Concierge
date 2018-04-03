class UserRepository < Hanami::Repository
    def find_user_by_tel(tel)
        users.where(tel: tel).first
    end

    def change_name(tel,new_name)
        user = users.where(tel: tel).first
        UserRepository.new.update(user.id, name: new_name)
    end
end
