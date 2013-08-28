Vagrant.configure("2") do |config|
  # Original base box.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef-cookbooks"
    chef.add_recipe("nginx")
    chef.add_recipe("php-fpm")
    chef.add_recipe("mysql")

    chef.json = {
      'nginx' => {
        'version' => '1.4.2',
        'user' => 'vagrant',
        'includes' => [ '/vagrant/nginx.conf' ],
      },
      'php' => {
        'version' => '5.5.3',
        'ini_location' => '/usr/local/etc',
        'display_errors' => 'On',
        'display_startup_errors' => 'On',
        'error_reporting' => 'E_ALL & E_STRICT',
        'log_errors' => 'Off',
      },
      'fpm' => {
        'pools' => {
          'www' => {
            'user' => 'vagrant',
            'group' => 'vagrant',
          },
        },
      },
    }

    chef.log_level = :debug
  end
end
