class TimeTableUtils
    def self.parse_time_state (time_state)
        time_state_parsed={
            Mon: [],
            Tues: [],
            Wed: [],
            Thur: [],
            Fri: [],
            Sat: [],
            Sun: [],
            Holiday: [],
            Special: []
        }
        time_state["normal"].each do |period|
            period["weekday"].each do |day|
                raise "Fail in parse time"  unless period["time"] =~ /\d{2}:\d{2}-\d{2}:\d{2}/
                raise "Fail in parse limit" unless period["limit"].class == Fixnum
                time_state_parsed[day.to_sym] << {time: period["time"], limit: period["limit"]}
            end
        end
        time_state_parsed[:Special] = time_state["special"]
    
        time_state_parsed.each do |key,value|
            time_state_parsed[key] = value.sort { |a, b|  a[:time] <=> b[:time] }
        end
    end

    def make_time_table (time_state, days, project_id)
        i = 0
        j = 0
        while i < days
            case (Date.today+j).wday
            when 0, !time_state[:Sun].empty?
                create_line((Date.today + j), time_state[:Sun], project_id)
            when 1, !time_state[:Mon].empty?
                create_line((Date.today + j), time_state[:Mon], project_id)
            when 2, !time_state[:Tues].empty?
                create_line((Date.today + j), time_state[:Tues], project_id)
            when 3, !time_state[:Wed].empty?
                create_line((Date.today + j), time_state[:Wed], project_id)
            when 4, !time_state[:Thur].empty?
                create_line((Date.today + j), time_state[:Thur], project_id)
            when 5, !time_state[:Fri].empty?
                create_line((Date.today + j), time_state[:Fri], project_id)
            when 6, !time_state[:Sat].empty?
                create_line((Date.today + j), time_state[:Sat], project_id)
            else
                i -= 1
            end
            i += 1
            j += 1
        end
    end

    def create_line (date, state, project_id)
        
    end


    
end