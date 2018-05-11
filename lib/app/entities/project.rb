class Project < Hanami::Entity
  def min_time
    return DateTime.now unless ahead_time
    return (Date.today + ahead_time[:day].to_i).to_datetime unless ahead_time[:day].blank?
    return (Time.now + ahead_time[:hour].to_i * 3600).to_datetime unless ahead_time[:hour].blank?
    return (Time.now + ahead_time[:minute].to_i * 60).to_datetime unless ahead_time[:minute].blank?
    DateTime.now
  end
end
