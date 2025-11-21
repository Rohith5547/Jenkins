#! /usr/bin/bash

unzip -o /home/ec2-user/$1 -d /home/ec2-user/App/
cd /home/ec2-user/App/
./venv/bin/python3 -m pip install --upgrade pip
./venv/bin/python3 -m pip install -r requirements.txt
sudo systemctl restart flaskapp.service
