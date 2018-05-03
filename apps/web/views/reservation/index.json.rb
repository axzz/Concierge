module Web::Views::Reservation
  class Index
    include Web::View
      format :json

      def render
        raw ({
          count: count,
          reservations: transformed_reservations
        }.to_json)
      end

      private

      def transformed_reservations
        reservations.map do |reservation|
          {
            id:           reservation[:reservation_id],
            state:        reservation[:state],
            date:         reservation[:date],
            time:         reservation[:time],
            name:         reservation[:name],
            tel:          reservation[:tel],
            remark:       reservation[:remark]
          }
        end  
      end
  end
end
