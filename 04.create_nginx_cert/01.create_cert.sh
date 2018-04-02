#!/bin/bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx.key -out nginx.crt -subj "/C=SL/ST=Know-Where/L=Terra/O=StarLord/OU=Guardians/CN=*.k8s.local"

