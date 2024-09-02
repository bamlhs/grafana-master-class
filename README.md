# grafana-master-class

This project aimed to run on Mac M1 using vmware_desktop

Vagrant main commands

```
vagrant global-status
vagrant up
vagrant destroy
vagrant provision
```

To install SCP
`vagrant plugin install vagrant-scp`

```
cd app
 vagrant scp ../scripts/setup_cronjob.sh :~

```

to Install Node exporter

```
 vagrant scp ../scripts/install_node_exporter.sh :~
 vagrant ssh
 chmod a+x ~/install_node_exporter.sh
 ~/./install_node_exporter.sh

curl http://localhost:9100/metrics

```

to Install mysql exporter

```
cd db
 vagrant scp ../scripts/install_mysql_exporter.sh :~
 vagrant ssh
 chmod a+x ~/install_mysql_exporter.sh
 ~/./install_mysql_exporter.sh
curl http://localhost:9104/metrics
```

to Install redis exporter

```
cd redis
 vagrant scp ../scripts/install_redis_exporter.sh :~
 vagrant ssh
 chmod a+x ~/install_redis_exporter.sh
 ~/./install_redis_exporter.sh
curl http://localhost:9121/metrics
```

to fix the time sync issue

```
sudo apt-get update
sudo apt-get install chrony -y
sudo systemctl start chrony
sudo systemctl enable chrony
sudo chronyc makestep
```

to add custom metric to db

```
cd db
 vagrant scp ../scripts/custom_exporter.sh :~
 vagrant ssh
sudo mkdir -p /var/lib/node_exporter/textfile_collector
sudo cp custom_exporter.sh /opt/custom_exporter.sh
sudo chmod a+x /opt/custom_exporter.sh
crontab -e
```

`*/2 * * * * /opt/custom_exporter.sh`

add in `/etc/systemd/system/node_exporter.service`

`--collector.textfile.directory=/var/lib/node_exporter/textfile_collector`

```
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
```

Now we have to update the prometheus.yml

```
 # Scrape configuration for Node Exporter
  - job_name: "node_exporter"
    static_configs:
      - targets:
        - "192.168.33.10:9100"
        - "192.168.33.11:9100"
        - "192.168.33.15:9100"

  # Scrape configuration for MySQL Exporter
  - job_name: "mysql_exporter"
    static_configs:
      - targets: ["192.168.33.11:9104"]

  # Scrape configuration for Redis
  - job_name: "redis"
    static_configs:
      - targets: ["192.168.33.15:9121"]
```

then restart the service
`systemctl restart prometheus`

To enable the Alert Rules

```
cd grafana
vagrant scp  ../scripts/rules :~
vagrant ssh
sudo mv rules  /etc/prometheus
```

update the prometheus.yml

```
rule_files:
- "rules/node_alert.rules.yml"
- "rules/mysqld_alert.rules.yml"
- "rules/redis_alert.rules.yaml"
```

then restart the service

`systemctl restart prometheus`



to test the max connection

```
#!/bin/bash
# Number of connections to simulate
CONNECTIONS=80
for i in $(seq 1 $CONNECTIONS); do
mysql -e "SELECT SLEEP(300);" &
done
```

to stop
`ps aux | grep "max"`
