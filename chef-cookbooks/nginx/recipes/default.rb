include_recipe "apt::update"
include_recipe "build-essential"

package "libpcre3-dev" do
	options "-q"
	action :upgrade
end

user node[:nginx][:user] do
	action :create
end

directory "/home/vagrant/build" do
	owner "vagrant"
	group "vagrant"
	mode "0755"
	action :create
	recursive true
end

remote_file "/home/vagrant/build/nginx-#{node[:nginx][:version]}.tar.gz" do
  mode "0644"
  source "http://nginx.org/download/nginx-#{node[:nginx][:version]}.tar.gz"
  checksum node[:nginx][:checksum]
end

bash "compile_nginx_source" do
	cwd "/home/vagrant/build"
	code <<-EOH
		tar zxf nginx-#{node[:nginx][:version]}.tar.gz
		cd nginx-#{node[:nginx][:version]}
		./configure #{node[:nginx][:configure_options]} && make && make install
	EOH
	creates "/usr/local/nginx/sbin/nginx"
end

directory "/var/www/default" do
	owner node[:nginx][:user]
	mode "0755"
	recursive true
	action :create
end

file "/var/www/default/index.html" do
	action :create
	owner node[:nginx][:user]
	mode "0644"
	content "<html><head><title>Nothing to see here</title></head><body>Nothing to see here, move along please.</body></html>"
end

service "nginx" do
	provider Chef::Provider::Service::Upstart
	subscribes :restart, resources(:bash => "compile_nginx_source")
	supports :restart => true, :start => true, :stop => true
end

template "nginx.conf" do
	path "/usr/local/nginx/conf/nginx.conf"
	source "nginx.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => :nginx)
end

directory "/usr/local/nginx/conf/includes" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
end

template "nginx.upstart.conf" do
	path "/etc/init/nginx.conf"
	source "nginx.upstart.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => "nginx")
end

service "nginx" do
	action [:enable, :start]
end
