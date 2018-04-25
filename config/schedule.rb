# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# env :PATH, ENV['PATH']

every 1.minute do
  command "echo 'abc111111111' > /home/kyon/test"
  rake 'refresh_reservationsssssssssssss'
end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
