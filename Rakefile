require 'fileutils'

task :default => :build

desc 'Build site with Jekyll'
task :build do
  sh 'rm -rf _site'
  sh 'jekyll build'
end

desc 'Start server with --watch'
task :server do
  sh 'jekyll serve --watch'
end

desc 'Start server without --watch'
task :noauto_server do
  sh 'jekyll serve'
end

