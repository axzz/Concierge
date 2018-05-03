class TimePeriod
  TIME_PERIOD_FORMAT = /([01][0-9]|2[0-3]):[0-5][0-9]-([01][0-9]|2[0-3]):[0-5][0-9]/
  TIME_ZONE = '+08'
  
  attr_reader :start, :end

  def initialize(time_str)
    raise 'Unsupport format' unless (time_str =~ TIME_PERIOD_FORMAT)

    start_str, end_str = time_str.split('-')
    @start = DateTime.parse(start_str + TIME_ZONE)
    @end = DateTime.parse(end_str + TIME_ZONE)
  end
end