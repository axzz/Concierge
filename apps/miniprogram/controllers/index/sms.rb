module Miniprogram::Controllers::Index
  # Get sms when make reservation
  class Sms
    include Miniprogram::Action

    def call(params)
      tel = params[:tel]
      project = ProjectRepository.new.find(params[:id].to_i)
      halt 404 unless project
      halt 403 unless project.state == 'open'

      sms_service = SmsService.new(tel, "reservation_#{project.id}")
      halt 400, { error: sms_service.error }.to_json unless sms_service.send_sms
      self.body = ''
    end
  end
end
