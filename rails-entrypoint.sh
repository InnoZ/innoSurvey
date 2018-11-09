#! /bin/bash
bundle exec rails assets:clobber
bundle exec rails assets:precompile

rake db:exists && rake db:migrate || rake db:setup

rm -rf ./tmp/pids/server.pid
bundle exec rails server
