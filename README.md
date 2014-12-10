autoban-ip-ddos
===============

## Install:
 
 ```sh
 sudo mkdir /opt/autoban
 
 sudo cp autoban.sh /opt/autoban
 
 sudo cp autoban-initd /etc/init.d/autoban
 
 sudo /sbin/chkconfig autoban --add
 
 sudo /sbin/chkconfig autoban on
```

## Start service:
```sh
 sudo service autoban start
```

## Stop service:
```sh
 sudo service autoban stop
```

## Restart service:
```sh
 sudo service autoban restart
```
