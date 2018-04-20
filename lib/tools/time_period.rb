class TimePeriod
  attr_reader :error

  def initialize(time_str)
    @time_str = time_str
    @error =~ /([01][0-9]|2[0-3]):[0-5][0-9]-([01][0-9]|2[0-3]):[0-5][0-9]/
  end

  def start_time
    str = @time_str[0..4] + '+08'
    DateTime.parse(str)
  end

  def end_time
    str = @time_str[-5..-1] + '+08'
    DateTime.parse(str)
  end
end
