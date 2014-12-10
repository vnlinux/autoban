autoban-ip-ddos
===============

-- Install:
 
 sudo mkdir /opt/autoban
 
 sudo cp autoban.sh /opt/autoban
 
 sudo cp autoban-initd /etc/init.d/autoban
 
 sudo /sbin/chkconfig autoban --add
 
 sudo /sbin/chkconfig autoban on

Start service:
 sudo service autoban start

Stop service:
 sudo service autoban stop

Restart service:
 sudo service autoban restart
