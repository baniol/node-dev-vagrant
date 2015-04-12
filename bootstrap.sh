#! /bin/bash

PROJECT_DIR="/Projects"

# echo "ADD EXTRA ALIAS VIA .bashrc"
# cat /vagrant/bashrc.append.txt >> /home/vagrant/.bashrc


yum list updates > /dev/null

yum install -y gcc-c++ make

yum list installed "epel-release" > /dev/null>&1
if [[ $? -ne 0 ]]; then
   sudo yum install epel-release -y
fi

yum list installed "nginx" > /dev/null>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install Nginx"
   sudo yum install nginx -y
fi

echo "Configuring Nginx"
rm /etc/nginx/conf.d/default.conf
cp -r /Projects/provision/config/nginx_vhost /etc/nginx/conf.d/default.conf
service nginx restart

locate --version > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install mlocate & run updatedb"
   yum install mlocate -y
   updatedb
fi

node -v > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install Node.js & npm"
   curl -sL https://rpm.nodesource.com/setup | bash -
   yum install nodejs -y
fi

pm2 --version > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install PM2"
   npm install --unsave-perm pm2 -g
fi

pm2 kill

bower -v > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install bower"
   npm install bower -g
fi

gulp -v > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install gulp"
   npm install gulp -g
fi

node-inspector -v > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
   echo " >>> Install node inspector"
   npm install -g node-inspector
fi

echo " >>> Replacing pm2-web config.json"
cp -r /Projects/provision/config/pm2-web-config.json /usr/lib/node_modules/pm2-web/config.json

pm2 start /usr/bin/node-inspector

echo " >>> Try to launch pm2-web monitor tool"
if [ -f /usr/lib/node_modules/pm2-web/pm2-web.js ]; then
   pm2 start /usr/lib/node_modules/pm2-web/pm2-web.js
else
   npm install --unsave-perm pm2-web -g
   pm2 start /usr/lib/node_modules/pm2-web/pm2-web.js
fi

# echo " >>> Launch example nodejs server"
pm2 start /Projects/node_test/server.js > /dev/null

# Custom repo example
if [ -d ${PROJECT_DIR}/tree-manager ]; then
   git clone https://github.com/baniol/tree-manager.git ${PROJECT_DIR}/tree-manager
   cd ${PROJECT_DIR}/tree-manager;npm install
   cd ${PROJECT_DIR}/tree-manager/example;npm install;pm2 start index.js
fi

echo "Done!"