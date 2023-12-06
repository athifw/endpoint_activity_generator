# endpoint_activity_generator

The Endpoint Activity Generator can generate endpoint activity on Linux and MacOS. These endpoints are:
- starting a process
- creating a file
- modifying a file
- deleting a file
- establishing a network connection

After generating an activity, the activity will be logged in `activity_log.json`.

### Prerequisites

Ensure that ruby version 3.2.2 is installed.

### Starting a Process

To start a process:
```sh
ruby endpoint_activity_generator.rb start_process [path_to_process] [arguments]
```

Example:
```sh
ruby endpoint_activity_generator.rb start_process sleep 5
```

This will generate the following log entry in `activity_log.json`:

```json
{
  "pid": 1,
  "process_command_line": "sleep 5",
  "start_time": "2023-12-05 16:53:53 -0600",
  "username": "username",
  "process_name": "sleep"
}
```

### Creating a File

To create a file:
```sh
ruby endpoint_activity_generator.rb create_file [filepath]
```

Example:
```sh
ruby endpoint_activity_generator.rb create_file newfile.md
```

This will generate the following log entry in `activity_log.json`:

```json
{
  "pid": 1,
  "process_command_line": "touch newfile.md",
  "start_time": "2023-12-05 16:53:53 -0600",
  "username": "user",
  "filepath": "newfile.md",
  "process_name": "touch",
  "activity_descriptor": "create"
}
```

### Modifying a File

To modify a file:
```sh
ruby endpoint_activity_generator.rb modify_file [filepath]
```

Example:
```sh
ruby endpoint_activity_generator.rb modify_file newfile.md
```

This will modify `newline.md` with additional text.

This will also generate the following log entry in `activity_log.json`:

```json
{
  "pid": 1,
  "process_command_line":  "echo 'Modified at 2023-12-05 09:41:36 -0600' >> newfile.md",
  "start_time": "2023-12-05 16:53:53 -0600",
  "username": "user",
  "filepath": "newfile.md",
  "process_name": "echo",
  "activity_descriptor": "modify"
}
```

### Deleting a File

To delete a file:
```sh
ruby endpoint_activity_generator.rb delete_file [filepath]
```

Example:
```sh
ruby endpoint_activity_generator.rb delete_file newfile.md
```

This will also generate the following log entry in `activity_log.json`:

```json
{
  "pid": 1,
  "process_command_line":  "rm newfile.md",
  "start_time": "2023-12-05 16:53:53 -0600",
  "username": "user",
  "filepath": "newfile.md",
  "process_name": "rm",
  "activity_descriptor": "delete"
}
```

### Establishing a network connection

To establish a network connection:
```sh
ruby endpoint_activity_generator.rb establish_connection [url]
```

Example:
```sh
ruby endpoint_activity_generator.rb establish_connection https://www.google.com
```

This will make a POST request to the specified URL with a payload specified in `source.json`. 
The following log entry will be generated:

```json
 {
  "pid": 1,
  "process_command_line": "curl -w 'Data: %{local_ip} %{local_port} %{remote_ip} %{remote_port} %{size_request}' -vX POST \"https://www.google.com\" -d @source.json --header \"Content-Type: application/json\"",
  "start_time": "2023-12-05 09:23:55 -0600",
  "username": "user",
  "local_ip": "165.71.82.141",
  "local_port": "52320",
  "remote_ip": "142.250.190.4",
  "remote_port": "443",
  "request_size_in_bytes": "129",
  "data_protocol": "json",
  "process_name": "curl"
}
```
