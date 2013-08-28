include_recipe "apt::update"

group "mysql" do
	action :create
end

user "mysql" do
	group "mysql"
	system true
	supports :manage_home => false
end

package "libaio1" do
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

remote_file "/home/vagrant/build/mysql-#{node[:mysql][:version]}.tar.gz" do
  action :create_if_missing
  owner "root"
  group "root"
  mode "0644"
  source "http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-#{node[:mysql][:version]}.tar.gz"
  checksum node[:mysql][:checksum]
end

bash "install_files_and_create_db" do
	cwd "/home/vagrant/build"
	code <<-EOH
		tar zxf mysql-#{node[:mysql][:version]}.tar.gz
		mv mysql-#{node[:mysql][:version]} /usr/local/
		ln -s /usr/local/mysql-#{node[:mysql][:version]} /usr/local/mysql
		cd /usr/local/mysql
		chown -R mysql .
		chgrp -R mysql .
		./scripts/mysql_install_db --user=mysql
		chown -R root .
		chown -R mysql data
	EOH
	creates "/usr/local/mysql/bin/mysqld_safe"
end

service "mysql" do
	provider Chef::Provider::Service::Upstart
	subscribes :restart, resources(:bash => "install_files_and_create_db")
	supports :restart => true, :start => true, :stop => true
end

template "my.cnf" do
	path "/usr/local/mysql/my.cnf"
	source "my.cnf.erb"
	owner "root"
	group "mysql"
	mode "0644"
	notifies :restart, resources(:service => 'mysql')
end

template "mysql.upstart.conf" do
	path "/etc/init/mysql.conf"
	source "mysql.upstart.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => 'mysql')
end

service "mysql" do
	action [:enable, :start]
end

link "/usr/local/bin/mysql" do
	to "/usr/local/mysql/bin/mysql"
end

