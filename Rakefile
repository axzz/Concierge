require 'rake'
require 'hanami/rake_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
  t.warning = false
end

# Rake::TestTask.new do |t|
#   t.pattern = 'spec/miniprogram/controllers/reservation/create_spec.rb'
#   t.libs << 'spec'
#   t.warning = false
# end

task default: :test
task spec: :test

# TODO: deal with crontab when deploy
task refresh_reservations: :environment do
  ReservationRepository.new.refresh_reservations
end

task everyday_send_to_manager: :environment do
  ProjectRepository.new.everyday_send_to_manager
end

task one_hour_notice: :environment do
  ReservationRepository.new.one_hour_notice
end