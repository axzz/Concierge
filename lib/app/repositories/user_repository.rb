class UserRepository < Hanami::Repository
    def find_user_by_tel(tel)
        users.where(tel: tel).first
    end

    def find_user_by_tel_SMS(tel,code)
        users.where(tel: tel).where(SMS: code).first
    end

    def verify_token(tel,token)
        #验证
        user=users.where(tel: tel).where(token: token).first
        if user.nil?
            return false
        elsif Time.now>user.token_limit
            return false
        end
        #延迟token_limit
        UserRepository.new.update(user.id,token_limit: (Time.now+(3600*36)))
        return true
    end

    def logout(tel)
        user=users.where(tel: tel).first
        UserRepository.new.update(user.id,token_limit: (Time.now-1))
    end
end
