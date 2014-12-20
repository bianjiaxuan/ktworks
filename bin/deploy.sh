#!/bin/sh
git pull
rake assets:clean
RAILS_ENV=production rake tmp:clear
RAILS_ENV=production rake assets:precompile
sudo nginx -s reload
