require 'json'
require 'etc'

LOG_FILENAME = "activity_log.json"

def activity_generator(command, input_array)
  case command
  when "start_process"
    start_process(input_array)
  when "create_file"
    crud_file("create", input_array)
  when "modify_file"
    crud_file("modify", input_array)
  when "delete_file"
    crud_file("delete", input_array)
  when "establish_connection"
    establish_connection(input_array)
  end
end

def start_process(input_array)
  path, *args = input_array
  process_command_line = "#{path} #{args.join(' ')}"

  io = IO.popen(process_command_line)
  pid = io.pid

  io.close

  process_json = { 
    "pid" => pid,
    "process_command_line" => process_command_line,
    "start_time" => get_start_time,
    "username" => get_username,
    "process_name" => path
  }
  log(process_json)
end

def crud_file(method, input_array)
  path = input_array[0]
  cruds = {
    "create" => ["touch", "touch"],
    "modify" => ["echo", "echo 'Modified at #{Time.now}' >>"],
    "delete" => ["rm", "rm"]
  }

  process, command_prefix = cruds[method]
  process_command_line = "#{command_prefix} #{path}"

  io = IO.popen(process_command_line)
  pid = io.pid

  io.close

  file_json = {
    "pid" => pid,
    "process_command_line" => process_command_line,
    "start_time" => get_start_time,
    "username" => get_username,
    "filepath" => path,
    "process_name" => process,
    "activity_descriptor" => method
  }
  log(file_json)
end

def establish_connection(input_array)
  url = input_array[0]

  process_command_line = "curl -w 'Data: %{local_ip} %{local_port} %{remote_ip} %{remote_port} %{size_request}' "\
                         "-vX POST \"#{url}\" -d @source.json --header \"Content-Type: application/json\""
  io = IO.popen(process_command_line)

  pid = io.pid
  output = io.read
  io.close

  local_ip, local_port, remote_ip, remote_port, request_size = output.match(/Data:\s*(.*)/)[1].split(" ")

  json = {
    "pid" => pid,
    "process_command_line" => process_command_line,
    "start_time" => get_start_time,
    "username" => get_username,
    "local_ip" => local_ip,
    "local_port" => local_port,
    "remote_ip" => remote_ip,
    "remote_port" => remote_port,
    "request_size_in_bytes" => request_size,
    "data_protocol" => "json",
    "process_name" => "curl"
  }
  log(json)
end

def get_start_time
  Time.now
end

def get_username
  uid = Process.uid
  Etc.getpwuid(uid).name
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
