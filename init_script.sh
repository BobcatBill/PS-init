DATE=$(date)
ROLE=$(whoami)

if [[ $ROLE != "root" ]]; then
	echo "$DATE [ERROR] - You must be root to run this script"
	exit 1
fi

if [[ $1 = "" ]]; then
	echo "$DATE [ERROR] - No customer name supplied"
	exit 1
fi

echo "$DATE [INFO] - Creating customer directories for $1"
mkdir /opt/$1
mkdir /opt/$1/data
mkdir /opt/$1/scripts

echo "$DATE [INFO] - Changing permissions to skyboxview user"
chown -R skyboxview:skyboxview /opt/$1

echo "$DATE [INFO] - Changing swappiness"
sysctl vm.swappiness=0

echo "$DATE [INFO] - Adding custom aliases"
ALIASCHECK=$(grep 'alias sdebug' /home/skyboxview/.bashrc)
if [[ $ALIASCHECK != "" ]]; then
	echo "$DATE [INFO] - sdebug alias already exists.  Skipping..."
else
	echo "alias sdebug=\"tail -f /opt/skyboxview/server/log/debug/debug.log\"" >> /home/skyboxview/.bashrc
fi

ALIASCHECK=$(grep 'alias cdebug' /home/skyboxview/.bashrc)
if [[ $ALIASCHECK != "" ]]; then
        echo "$DATE [INFO] - cdebug alias already exists.  Skipping..."
else
	echo "alias cdebug=\"tail -f /opt/skyboxview/collector/log/debug/debug.log\"" >> /home/skyboxview/.bashrc
fi

ALIASCHECK=$(grep 'alias specget' /home/skyboxview/.bashrc)
if [[ $ALIASCHECK != "" ]]; then
        echo "$DATE [INFO] - specget alias already exists.  Skipping..."
else
	echo "alias specget=“grep ‘routing table speculation’ /opt/skyboxview/server/log/server.log | awk -F’speculation on’ ‘{print " >> /home/skyboxview/.bashrc
fi

CHECK=$(grep 'top -b | head -12' /home/skyboxview/.bashrc)
if [[ $CHECK != "" ]]; then
	echo "$DATE [INFO] - top/appliance alias already exists.  Skipping..."
else
	echo "top -b | head -12" >> /home/skyboxview/.bashrc
	echo "echo \"-------------\"" >> /home/skyboxview/.bashrc
	echo "get_appliance_details" >> /home/skyboxview/.bashrc
fi

echo "$DATE [INFO] - Script Complete"
exit 0
