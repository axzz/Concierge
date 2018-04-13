class UserRepository < Hanami::Repository
  def find_by_tel(tel)
    users.where(tel: tel).first
  end

  def find_by_openid(openid)
    users.where(openid: openid).first
  end

  def change_name(tel,new_name)
    user = users.where(tel: tel).first
    UserRepository.new.update(user.id, name: new_name)
  end
end
