# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#
#whenever -s environment=development -iw
#
#
# keep order( agentReport after Inviter.static_lives)
every :day, :at => '3:00 am' do
  #rake "agent_report:agent_count"
  puts "runner--AgentReport.agent_count---begin#{Time.now}"
  runner "AgentReport.agent_count"
  puts "runner--AgentReport.agent_count---end#{Time.now}"
end

every :day, :at => '1:30 am' do
  #rake "agent_report:agent_count"
  puts "runner--JudgeRank.judge_rank_score---begin#{Time.now}"
  runner "JudgeRank.judge_rank_score"
  puts "runner--JudgeRank.judge_rank_score---end#{Time.now}"
end

every :day, :at => '2:00 am' do
  puts "runner--Inviter.static_lives---begin#{Time.now}"
  runner "Inviter.static_lives"
  puts "runner--Inviter.static_lives---end#{Time.now}"
end
