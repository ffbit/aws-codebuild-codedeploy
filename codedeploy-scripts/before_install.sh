#!/bin/bash
set -x

amazon-linux-extras install nginx1
systemctl enable nginx
systemctl start nginx

curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
yum -y install nodejs
node --version


# https://pm2.keymetrics.io/docs/usage/process-management/
npm install -g pm2

