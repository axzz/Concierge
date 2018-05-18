module Web::Controllers::Index
  # Handle SMS sending
  class Sms
    include Web::Action

    handle_exception ArgumentError => 422

    def call(params)
      tel = params[:tel]

      unless UserRepository.new.find_by_tel(tel)
        halt 403, { error: 'Unregistered' }.to_json
      end

      sms_service = SmsService.new(tel)
      if sms_service.send_sms
        self.body = ''
      else
        halt 400, { error: sms_service.error }.to_json
      end
    end

    private

    def authenticate!
      # skip auth
    end
  end
end
