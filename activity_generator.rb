require 'json'

LOG_FILENAME = "activity_log.json"

def activity_generator(command, input_array)
  case command
  when "start_process"
    start_process(input_array)
  end
end

def start_process(input_array)
  path, *args = input_array
  process_command_line = "#{path} #{args.join(' ')}"
  pid = Process.spawn process_command_line

  start_time = get_start_time(pid)
  username = get_username(pid)
  process_json = { 
    "pid" => pid,
    "process_command_line" => process_command_line,
    "start_time" => start_time.strip,
    "username" => username.strip,
    "process_name" => path
  }
  log(process_json)
end

def get_start_time(pid)
  `ps -o lstart= -p #{pid}`
end

def get_username(pid)
  `ps -o uname= -p #{pid}`
end

def log(json_to_add)
  unless File.file? LOG_FILENAME
    File.open(LOG_FILENAME, 'w') do |f|
      f.write(JSON.pretty_generate([]))
    end
  end

  log_array = JSON.parse(File.read(LOG_FILENAME))
  log_array << json_to_add

  File.open(LOG_FILENAME, 'w') do |f|
    f.write(JSON.pretty_generate(log_array))
  end
end

command, *input_array = ARGV

activity_generator(command, input_array)
