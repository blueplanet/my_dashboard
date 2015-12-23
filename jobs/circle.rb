require 'circleci'
require 'dotenv'
Dotenv.load

CircleCi.configure do |config|
  config.token = ENV['CIRCLE_CI_API_TOKEN']
end

SCHEDULER.every '10s' do
  begin
    items = CircleCi::Project.recent_builds(ENV['CIRCLE_CI_USER'], ENV['CIRCLE_CI_REPO']).body.map do |build|
      label = "##{build['build_num']} [#{build['branch']}] #{build['subject']}"
      { label: label, value: build['status'] }
    end.first(10)

    send_event('circle_builds', title: 'mynavi-cms builds', items: items)
  end
end
