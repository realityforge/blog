require 'fileutils'

task :default => :build

desc 'Build site with Jekyll'
task :build do
  sh 'rm -rf _site'
  sh 'jekyll build'
end

desc 'Start server with --auto'
task :server do
  sh 'jekyll --server --auto'
end

desc 'Start server without --auto'
task :noauto_server do
  sh 'jekyll --server'
end

