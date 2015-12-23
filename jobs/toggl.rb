require 'togglv8'
require 'dotenv'
Dotenv.load

api = TogglV8::API.new(ENV['TOGGL_API_TOKEN'])

SCHEDULER.every '5s' do
  begin
    current_time_entry = api.get_current_time_entry
    description = current_time_entry['description'] || '説明なし'
    project_name = 'プロジェクト名称'

    unless current_time_entry['pid'].nil?
      project_name = api.get_project(current_time_entry['pid'])['name']
    end

    send_event('current_task', title: project_name, text: description)
  end
end
