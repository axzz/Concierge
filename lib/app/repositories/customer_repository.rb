class CustomerRepository < Hanami::Repository
  def find_by_openid(openid)
    customers.where(openid: openid).first
  end
end
