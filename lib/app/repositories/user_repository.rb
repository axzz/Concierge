# Repository for 'users' table
class UserRepository < Hanami::Repository
  def find_by_tel(tel)
    users.where(tel: tel).first
  end

  def find_by_openid(openid)
    users.where(openid: openid).first
  end
end
