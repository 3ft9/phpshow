node.default[:php][:version] = "5.5.3"
node.default[:php][:checksum] = "93080dd06dff7c4e54254f4bd6910e7cc4049d6226e6ac4c9bc52c16ebd5939a"
node.default[:php][:ini_location] = '/usr/local/etc'
node.default[:php][:ini_scandir] = '/usr/local/etc/php.d'
node.default[:php][:configure_options] = ''

node.default[:fpm][:pid] = '/var/run/php-fpm.pid'
node.default[:fpm][:error_log] = '/var/log/php-fpm.log'
node.default[:fpm][:log_level] = 'warning'
node.default[:fpm][:daemonize] = 'yes'
node.default[:fpm][:pools] = {
	:www => {
		'listen' => '127.0.0.1:10000',
		'listen.backlog' => -1,
		'listen.allowed_clients' => '127.0.0.1',
		'user' => 'nobody',
		'group' => 'nobody',
		'pm' => 'dynamic',
		'pm.max_children' => 50,
		'pm.start_servers' => 10,
		'pm.min_spare_servers' => 5,
		'pm.max_spare_servers' => 35,
		'pm.max_requests' => 500,
	}
}
