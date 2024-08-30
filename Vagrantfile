
Vagrant.configure("2") do |config|
  config.vm.provider "vmware_desktop" do |v|
    v.gui = false  # Set to true if you need a GUI
  end
  	
  config.vm.define "laravel-app" do |laravel|
    laravel.vm.box = "bento/debian-11"
    laravel.vm.box_version = "202407.22.0"
   # laravel.vm.architecture = "arm64"
    laravel.vm.network "private_network", type: "dhcp"
    laravel.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y apache2 php php-cli php-mbstring php-xml php-bcmath unzip curl mysql-server redis-server
      curl -sS https://getcomposer.org/installer | php
      mv composer.phar /usr/local/bin/composer
      composer create-project --prefer-dist laravel/laravel laravel-app
      mv /vagrant/laravel-app /var/www/laravel-app
      chown -R www-data:www-data /var/www/laravel-app
      a2enmod rewrite
      service apache2 restart
    SHELL
  end

  config.vm.define "mysql-cluster" do |mysql|
    mysql.vm.box = "bento/debian-11"
    mysql.vm.box_version = "202407.22.0"
   # mysql.vm.architecture = "arm64"
    mysql.vm.network "private_network", type: "dhcp"
    mysql.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y mysql-server
      mysql -e "CREATE DATABASE laravel_db;"
    SHELL
  end

  config.vm.define "haproxy" do |haproxy|
    haproxy.vm.box = "bento/debian-11"
    haproxy.vm.box_version = "202407.22.0"
   # haproxy.vm.architecture = "arm64"
    haproxy.vm.network "private_network", type: "dhcp"
    haproxy.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y haproxy
      cat <<EOT >> /etc/haproxy/haproxy.cfg
      frontend mysql-cluster
        bind *:3306
        default_backend mysql-backend

      backend mysql-backend
        balance roundrobin
        server mysql1 192.168.33.11:3306 check
        server mysql2 192.168.33.12:3306 check
      EOT
      service haproxy restart
    SHELL
  end

  config.vm.define "prometheus-grafana" do |monitor|
    monitor.vm.box = "bento/debian-11"
    monitor.vm.box_version = "202407.22.0"
    #monitor.vm.architecture = "arm64"
    monitor.vm.network "private_network", type: "dhcp"
    monitor.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y prometheus grafana mysql-client apache2-utils
      wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.11.0/mysqld_exporter-0.11.0.linux-amd64.tar.gz
      tar xvfz mysqld_exporter-0.11.0.linux-amd64.tar.gz
      mv mysqld_exporter-0.11.0.linux-amd64/mysqld_exporter /usr/local/bin/
      echo "starting prometheus and grafana"
      systemctl start prometheus
      systemctl enable prometheus
      systemctl start grafana-server
      systemctl enable grafana-server
    SHELL
  end
end
