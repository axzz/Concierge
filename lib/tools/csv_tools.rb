require 'csv'
require 'digest'
# require 'nfk'

class CsvTools
  def make_reservation_csv(reservations, project_id)
    name = DateTime.now.to_s + Digest::MD5.hexdigest("group_#{project_id}")
    path = "/excels/#{name}.csv"
    csv = CSV.generate do |csv|
      csv << ['姓名', '预约状态', '联系电话', '预约日期', '预约时间段', '备注']
      reservations.each do |reservation|
        csv << [reservation.name, map_state(reservation.state), reservation.tel, reservation.date, reservation.time, reservation.remark]
      end
    end
    
    file = File.new("public" + path, 'w')
    # utf8
    head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()  
    file.write head
    file.write csv
    file.close
    path
  end

  def map_state(state)
    return '已成功' if state == 'success'
    return '已取消' if state == 'cancelled'
    return '已过期' if state == 'overtime'
    return '待审核' if state == 'wait'
    return '已核销' if state == 'checked'
    '未知'
  end
end
