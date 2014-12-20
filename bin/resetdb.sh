#!/bin/sh
rm db/development.sqlite3 db/test.sqlite3
#rm db/schema.rb
rake db:migrate
RAILS_ENV=development rake db:setup
RAILS_ENV=test rake db:setup
#RAILS_ENV=production rake db:setup
