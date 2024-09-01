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


to fix the time sync issue 

```
sudo apt-get update
sudo apt-get install chrony -y
sudo systemctl start chrony
sudo systemctl enable chrony
sudo chronyc makestep
```

