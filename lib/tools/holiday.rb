class Date
  def holiday?
    holidays = JSON.parse(File.read("#{Hanami.root}/lib/app/holiday_data.json"))
    holidays.include?(to_s)
  end
end
