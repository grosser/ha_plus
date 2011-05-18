#!/usr/bin/env ruby

pid = File.expand_path('tmp/pids/thin.pid')

case ARGV[0]
when 'start' 
  exec "bundle exec thin start --daemonize --port 8701"
when 'stop' 
  exec "(test -e #{pid} && cat #{pid} | xargs --no-run-if-empty kill) || echo 'not running'"
when 'pid' 
  puts pid
else
  raise "Unknown first argument"
end