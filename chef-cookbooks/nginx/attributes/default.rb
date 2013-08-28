default[:nginx][:version] = "1.4.2"
default[:nginx][:checksum] = "5361ffb7b0ebf8b1a04369bc3d1295eaed091680c1c58115f88d56c8e51f3611"
default[:nginx][:user] = "vagrant"
default[:nginx][:worker_processes] = 1
default[:nginx][:worker_connections] = 1024
default[:nginx][:keepalive_timeout] = 0

default[:nginx][:includes] = [ 'conf/includes/*.conf' ]

default[:nginx][:configure_options] = ''
