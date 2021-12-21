#!/bin/bash
set -x

cd /var/app/current/

export PORT=8080
export MY_AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

# Does not survive a restart, follow up - https://pm2.keymetrics.io/docs/usage/startup/
pm2 start main/app.js

