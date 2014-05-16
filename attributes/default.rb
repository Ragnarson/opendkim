default[:opendkim][:config_file] = "/etc/opendkim.conf"
default[:opendkim][:config_dir] = "/etc/opendkim"
default[:opendkim][:enabled] = true
default[:opendkim][:user] = "opendkim"
default[:opendkim][:group] = "opendkim"
default[:opendkim][:service_config_file] = "/etc/default/opendkim"
default[:opendkim][:socket_type] = "inet" # local or inet
default[:opendkim][:socket_path] = "/var/run/opendkim/opendkim.sock" # only for local socket
default[:opendkim][:socket_port] = "54321" # only for inet socket
default[:opendkim][:listen_host] = "localhost" # only for inet socket, may be nil to listen on all hosts
default[:opendkim][:trusted_hosts] = [ "localhost", "127.0.0.1" ]

default[:opendkim][:sign_subdomains] = "yes"
default[:opendkim][:mode] = "s" # s - signer, v - verifier, may be combined 'sv' also
default[:opendkim][:syslog] = "yes"
default[:opendkim][:syslog_success] = "yes"
default[:opendkim][:log_why] = "yes"

default[:opendkim][:domains] = {
  "domain_name" => {
    "txt" => "txt_key", # base64 encoded
    "private" => "private_key" # base64 encoded
  }
}
