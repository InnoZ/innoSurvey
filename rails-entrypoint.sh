#! /bin/bash
bundle exec rails assets:clobber
bundle exec rails assets:precompile

bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:setup

rm -rf ./tmp/pids/server.pid
bundle exec rails server
