#! /bin/bash

# get the .default file
wget -qO/etc/default/azurefile-dockervolumedriver https://raw.githubusercontent.com/Azure/azurefile-dockervolumedriver/master/contrib/init/systemd/azurefile-dockervolumedriver.default

# get the .service file
wget -qO/etc/systemd/system/azurefile-dockervolumedriver.service https://raw.githubusercontent.com/Azure/azurefile-dockervolumedriver/master/contrib/init/systemd/azurefile-dockervolumedriver.service

# search and replace the defaults
sed -i "s/youraccount/${1}/g" /etc/default/azurefile-dockervolumedriver
sed -i "s/yourkey/${2}/g" /etc/default/azurefile-dockervolumedriver

# get the executable
wget -qO/usr/bin/azurefile-dockervolumedriver https://github.com/Azure/azurefile-dockervolumedriver/releases/download/0.2.1/azurefile-dockervolumedriver
chmod +x /usr/bin/azurefile-dockervolumedriver

# enable it
systemctl daemon-reload
systemctl enable azurefile-dockervolumedriver
systemctl start azurefile-dockervolumedriver

yum install -y docker

/usr/bin/docker volume create -d azurefile --name jenkins -o share=jenkins

/usr/bin/docker run -d -p 80:8080 -v jenkins:/var/jenkins_home jenkins
