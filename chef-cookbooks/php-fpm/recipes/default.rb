include_recipe "apt::update"
include_recipe "build-essential"
include_recipe "nginx"

package "libpcre3-dev" do
	options "-q"
	action :upgrade
end

package "libcurl4-openssl-dev" do
	options "-q"
	action :upgrade
end

package "libmcrypt-dev" do
	options "-q"
	action :upgrade
end

package "libxml2-dev" do
	options "-q"
	action :upgrade
end

package "re2c" do
	options "-q"
	action :upgrade
end

directory "/home/vagrant/build" do
	owner "vagrant"
	group "vagrant"
	mode "0755"
	action :create
	recursive true
end

remote_file "/home/vagrant/build/php-#{node[:php][:version]}.tar.bz2" do
  mode "0644"
  source "http://uk3.php.net/distributions/php-#{node[:php][:version]}.tar.bz2"
  checksum node[:php][:checksum]
end

directory "#{node[:php][:ini_scandir]}" do
	owner "root"
	group "root"
	mode 00755
	action :create
	recursive true
end

bash "compile_php_source" do
	cwd "/home/vagrant/build"
	code <<-EOH
		tar jxf php-#{node[:php][:version]}.tar.bz2
		cd php-#{node[:php][:version]}
		./configure --enable-fpm --with-config-file-path=#{node[:php][:ini_location]} --with-config-file-scan-dir=#{node[:php][:ini_scandir]} #{node[:php][:configure_options]}
		make && make install
		ln -s "/usr/local/bin/php" "/usr/local/bin/php#{node[:php][:version]}"
	EOH
	creates "/usr/local/bin/php#{node[:php][:version]}"
end

service "php-fpm" do
	provider Chef::Provider::Service::Upstart
	subscribes :restart, resources(:bash => "compile_php_source")
	supports :restart => true, :start => true, :stop => true
end

# This isn't pretty, but it works and will always follow the recommended production ini!
bash "copy and modify php.ini-production" do
	code <<-EOH
		echo "[PHP]" > "#{node[:php][:ini_location]}/php.ini"
		echo "display_errors = On" >> "#{node[:php][:ini_location]}/php.ini"
		echo "display_startup_errors = On" >> "#{node[:php][:ini_location]}/php.ini"
		echo "error_reporting = E_ALL | E_DEPRECATED | E_STRICT" >> "#{node[:php][:ini_location]}/php.ini"
		echo "log_errors = Off" >> "#{node[:php][:ini_location]}/php.ini"
		echo "error_log = syslog" >> "#{node[:php][:ini_location]}/php.ini"
		grep -v "error_reporting" "/home/vagrant/build/php-#{node[:php][:version]}/php.ini-production" \
		| grep -v "display_errors" \
		| grep -v "display_startup_errors" \
		| grep -v "error_reporting" \
		| grep -v "log_errors" \
		| grep -v "error_log" \
		| grep -v "[PHP]" >> "#{node[:php][:ini_location]}/php.ini"
	EOH
	notifies :restart, resources(:service => 'php-fpm')
end

template "php-fpm.conf" do
	path "/usr/local/etc/php-fpm.conf"
	source "php-fpm.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => 'php-fpm')
end

template "php-fpm.upstart.conf" do
	path "/etc/init/php-fpm.conf"
	source "php-fpm.upstart.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => 'php-fpm')
end

service "php-fpm" do
	action [:enable, :start]
end
