#!/usr/bin/env ruby

file 'arduino_library_index.json' do |task|
  sh 'curl',
     '--fail',
     '--output', task.name,
     'http://downloads.arduino.cc/libraries/library_index.json'
end

file 'library_index.json' => 'arduino_library_index.json' do |task|
  ruby 'bin/rebuild-index.rb'
end

task :rebuild => ['library_index.json'] do
  ruby 'bin/rebuild-site.rb'
end

task :server => :rebuild do
  require 'webrick'
  server = WEBrick::HTTPServer.new(
    :Port => 3000,
    :DocumentRoot => File.join(Dir.pwd, 'public')
  )
  trap('INT') { server.shutdown }
  server.start
end

task :upload => :rebuild do
  sh 'rsync -avz --delete -e ssh public/ njh@www.arduinolibraries.info:/srv/www/arduino-libraries/'
end

task :default => :rebuild

task :clean do
  File.foreach('.gitignore') do |line|
    # For safety
    next unless line =~ /^\w+/
    sh 'rm', '-Rf', line.strip
  end
end
