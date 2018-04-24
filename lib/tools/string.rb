class String
  def blank?
    nil? || empty?
  end
end

class NilClass
  def blank?
    nil?
  end
end