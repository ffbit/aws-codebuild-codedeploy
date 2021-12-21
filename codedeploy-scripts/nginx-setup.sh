#!/bin/bash

cp /var/app/current/nginx/nginx.conf /etc/nginx/

systemctl restart nginx

